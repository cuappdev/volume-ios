//
//  WeeklyDebriefView.swift
//  Volume
//
//  Created by Amy Chin Siu Huang on 12/1/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import Apollo
import AppDevAnalytics
import Combine
import LinkPresentation
import SDWebImageSwiftUI
import SwiftUI
import WebKit

struct WeeklyDebriefView: View {
    @Binding var isOpen: Bool
    @Binding var onOpenArticleUrl: String?
    @Binding var openedURL: Bool
    @EnvironmentObject private var userData: UserData
    @State private var articleStates = [ArticleID : MainView.TabState<Article>]()
    @State private var cancellableArticleQueries = [ArticleID : AnyCancellable]()
    @State private var currentPage: Int = 0
    
    let weeklyDebrief: WeeklyDebrief
    
    private var debriefSummary: some View {
        VStack {
            Image.volume.logo
                .resizable()
                .frame(width: 245, height: 75)
                .padding(.top, 24)
            Text("Your weekly debrief, \(weeklyDebrief.creationDate.simpleString) - \(weeklyDebrief.expirationDate.simpleString)")
                .padding(.vertical, 32)
                .font(.newYorkMedium(size: 16))
            
            Divider()
                .frame(width: 100)
                .padding(.bottom, 48)
            
            VStack(spacing: 24) {
                HStack {
                    Text("In the past week, you...")
                        .font(.newYorkRegular(size: 16))
                    
                    Spacer()
                }
                
                StatisticView(image: .volume.feed, leftText: "read", number: weeklyDebrief.numReadArticles, rightText: "articles")
                StatisticView(image: .volume.shoutout, leftText: "gave", number: weeklyDebrief.numShoutouts, rightText: "shout-outs")
                StatisticView(image: .volume.bookmark, leftText: "bookmarked", number: weeklyDebrief.numBookmarkedArticles, rightText: "articles")
                
                HStack {
                    Text("Keep up the volume! 📣")
                        .font(.newYorkRegular(size: 16))
                        .frame(alignment: .leading)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 48)
            
            Spacer()
        }
    }
    
    private var debriefConclusion: some View {
        VStack {
            Header("See You Next Week!", .center)
                .padding(.top, 24)
            
            VStack(spacing: 16) {
                Image.volume.logo
                    .resizable()
                    .frame(width: 245, height: 75)
                Text("Stay updated with Cornell student publications, all in one place")
                    .font(.newYorkRegular(size: 16))
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 200)

            Spacer()
            
            Button {
                isOpen = false
            } label: {
                Text("Continue to Volume")
                    .foregroundColor(.volume.orange)
                    .font(.helveticaBold(size: 16))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .overlay(RoundedRectangle(cornerRadius: 26)
                .stroke(Color.volume.orange, lineWidth: 2))
          
            Spacer()
                .frame(height: 100)
        }
        .padding(.horizontal, 50)
    }
    
    private func makeDebriefArticleView(articleID: ArticleID, header: String) -> some View {
        Group {
            switch articleStates[articleID] {
            case .loading, .none:
                DebriefArticleView.Skeleton()
            case .reloading(let article), .results(let article):
                DebriefArticleView(header: header,
                                   article: article,
                                   isDebriefOpen: $isOpen,
                                   isURLOpen: $openedURL,
                                   articleID: $onOpenArticleUrl)
            }
        }
    }
    
    var body: some View {
        TabView(selection: $currentPage) {
            debriefSummary
                .tag(0)
            
            ForEach(weeklyDebrief.readArticleIDs.indices, id: \.self) { idx in
                makeDebriefArticleView(articleID: weeklyDebrief.readArticleIDs[idx], header: "Share What You Read")
                    .tag(1 + idx)
            }
            
            ForEach(weeklyDebrief.randomArticleIDs.indices, id: \.self) { idx in
                makeDebriefArticleView(articleID: weeklyDebrief.randomArticleIDs[idx], header: "Top Articles of the Week")
                    .tag(1 + weeklyDebrief.readArticleIDs.count + idx)
            }
            
            debriefConclusion
                .tag(1 + weeklyDebrief.readArticleIDs.count + weeklyDebrief.randomArticleIDs.count)
        }
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .gray
            UIPageControl.appearance().pageIndicatorTintColor = .lightGray
            fetchDebriefArticles()
        }
        .onDisappear {
            UIPageControl.appearance().currentPageIndicatorTintColor = nil
            UIPageControl.appearance().pageIndicatorTintColor = nil
        }
    }
    
    // MARK: Network Requests
    
    private func fetchDebriefArticles() {
        for id in weeklyDebrief.readArticleIDs + weeklyDebrief.randomArticleIDs {
            fetchArticle(articleID: id)
        }
    }
    
    private func fetchArticle(articleID: ArticleID) {
        articleStates[articleID] = .loading
        cancellableArticleQueries[articleID] = Network.shared.publisher(for: GetArticleByIdQuery(id: articleID))
            .map(\.article?.fragments.articleFields)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: GetArticleByIdQuery failed on WeeklyDebriefView: \(error.localizedDescription)")
                }
            } receiveValue: { articleFields in
                guard let articleFields = articleFields else {
                    #if DEBUG
                    print("Error: received nil for articleID \(articleID) on WeeklyDebriefView")
                    #endif
                    return
                }
                
                articleStates[articleID] = .results(Article(from: articleFields))
            }
    }
}
