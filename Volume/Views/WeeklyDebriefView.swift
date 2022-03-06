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
    @EnvironmentObject private var userData: UserData
    private let weeklyDebrief: WeeklyDebrief?
    @Binding private var isOpen: Bool
    
    let initType: WeeklyDebriefViewInitType
    @State private var cancellableArticleQuery: AnyCancellable?
    @State private var cancellableReadMutation: AnyCancellable?
    @State private var cancellableShoutoutMutation: AnyCancellable?
    @State private var state: WeeklyDebriefViewState<Article> = .loading
    

    init(openedWeeklyDebrief: Binding<Bool>, weeklyDebrief: WeeklyDebrief) {
        _isOpen = openedWeeklyDebrief
        self.weeklyDebrief = weeklyDebrief
        
        #warning("This is a dummy article")
        self.initType = .fetchRequired("618f63022fef10d6b75ec9a8")
        
    }
    
    init(openedWeeklyDebrief: Binding<Bool>, dummyID: ArticleID) {
        _isOpen = openedWeeklyDebrief
        self.initType = .fetchRequired(dummyID)
        self.weeklyDebrief = nil
        
        print("TEeessttt")
    }
    
    var body: some View {
        VStack {
            switch state {
            case .loading:
                showTempSkeleton()
            case .results(let article):
                Capsule()
                    .fill(Color.secondary)
                    .frame(width: 64, height: 3)
                    .padding(10)
                TabView {
                    VStack {
                        Image("volume-logo")
                            .resizable()
                            .frame(width: 245, height: 75)
                            .padding(.top, 24)
                        
                        // TODO: Make these dates actually relevant to the week we are in!
                        Text("Your weekly debrief, 5/3 - 5/9")
                            .padding([.top, .bottom], 32)
                            .font(.begumMedium(size: 16))
                        Divider()
                            .frame(width: 100)
                            .padding(.bottom, 48)
                        VStack(spacing: 24, content: {
                            HStack {
                                Text("In the past week, you...")
                                    .font(.begumRegular(size: 16))
                                Spacer()
                            }
                            StatisticView(image: "volume", leftText: "read", number: 10, rightText: "articles")
                            StatisticView(image: "shout-out", leftText: "gave", number: 45, rightText: "shout-outs")
                            StatisticView(image: "bookmark", leftText: "bookmarked", number: 10, rightText: "articles")
                            HStack {
                                Text("You were among the top ")
                                    .font(.begumRegular(size: 16)) +
                                Text("10% ")
                                    .font(.begumMedium(size: 36))
                                    .foregroundColor(Color.volume.orange) +
                                Text("active readers last week!")
                                    .font(.begumRegular(size: 16))
                                Spacer()
                            }
                            HStack {
                                Text("Keep up the volume! 📣")
                                    .font(.begumRegular(size: 16))
                                    .frame(alignment: .leading)
                                Spacer()
                            }
                        })
                            .padding([.leading, .trailing], 48)
                        Spacer()
                    }

                    // TODO - create a DebriefArticleView for each article
                    DebriefArticleView(header: "Share What You Read", article: article)
                    DebriefArticleView(header: "Share What You Read", article: article)
    //                possiblyShowTheView(header: "Share What You Read")
                    
                    VStack {
                        Header("See You Next Week!", .center)
                            .padding(.top, 24)
                        VStack {
                            VStack {
                                Image("volume-logo")
                                    .resizable()
                                    .frame(width: 245, height: 75)
                                Text("Stay updated with Cornell student publications, all in one place")
                                    .font(.begumRegular(size: 16))
                            }
                            .padding(.top, 200)
                            Button {
                                isOpen = false
                            } label: {
                                Text("Continue to Volume")
                                    .foregroundColor(Color.volume.orange)
                                    .font(.helveticaBold(size: 16))
                            }
                            .frame(width: 184, height: 45, alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 26)
                            .stroke(Color.volume.orange, lineWidth: 2))
                            .padding(.top, 200)
                            Spacer()
                        }
                    }
                    .padding([.leading, .trailing], 50)
                }
                .tabViewStyle(PageTabViewStyle())
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .gray
            UIPageControl.appearance().pageIndicatorTintColor = .lightGray
        }
        .onDisappear {
            UIPageControl.appearance().currentPageIndicatorTintColor = nil
            UIPageControl.appearance().pageIndicatorTintColor = nil
        }
    }
    
    
    // MARK: - Copying from BrowserView
    
    private func showTempSkeleton() -> BigReadArticleRow.Skeleton {
        
        switch initType {
        case .readyForDisplay(let article):
            break
        case .fetchRequired(let articleID):
            fetchArticleBy(id: articleID)
        }
        
        print("Showing skeellleetonnn")
        
        return BigReadArticleRow.Skeleton()
    }
    
    private func fetchArticleBy(id: String) {
        state = .loading
        cancellableArticleQuery = Network.shared.publisher(for: GetArticleByIdQuery(id: id))
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            }
            receiveValue: { article in
                if let fields = article.article?.fragments.articleFields {
                    state = .results(Article(from: fields))
                    print("Got article \(fields.id)")
                }
            }
        Network.shared
    }
}

extension WeeklyDebriefView {
    private enum WeeklyDebriefViewState<Results> {
        case loading, results(Results)
    }
    
    enum WeeklyDebriefViewInitType {
        case readyForDisplay(Article), fetchRequired(ArticleID)
    }
}
