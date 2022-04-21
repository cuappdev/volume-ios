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
    @Binding var isOpen: Bool
    @Binding var openedURL: Bool
    @Binding var onOpenArticleUrl: String?
    @State private var cancellableArticleQuery: AnyCancellable?
    @State private var cancellableReadMutation: AnyCancellable?
    @State private var cancellableShoutoutMutation: AnyCancellable?
    @State private var state: MainView.TabState<WeeklyDebriefDisplayInfo> = .loading
    
    let weeklyDebrief: WeeklyDebrief
    
    func makeView(debriefDisplayInfo: WeeklyDebriefDisplayInfo) -> some View {
        VStack {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 64, height: 3)
                .padding(10)
            
            TabView {
                VStack {
                    Image.volume.logo
                        .resizable()
                        .frame(width: 245, height: 75)
                        .padding(.top, 24)
                    Text(getWeekString())
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
                        
                        StatisticView(image: .volume.feed, leftText: "read", number: debriefDisplayInfo.numReadArticles, rightText: "articles")
                        StatisticView(image: .volume.shoutout, leftText: "gave", number: debriefDisplayInfo.numShoutouts, rightText: "shout-outs")
                        StatisticView(image: .volume.bookmark, leftText: "bookmarked", number: debriefDisplayInfo.numBookmarkedArticles, rightText: "articles")
                        
                        HStack {
                            Text("You were among the top ")
                                .font(.newYorkRegular(size: 16)) +
                            Text("10% ")
                                .font(.newYorkMedium(size: 36))
                                .foregroundColor(.volume.orange) +
                            Text("active readers last week!")
                                .font(.newYorkRegular(size: 16))
                            
                            Spacer()
                        }
                        
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
                
                ForEach(debriefDisplayInfo.readArticles) { article in
                    DebriefArticleView(header: "Share What You Read",
                                       article: article,
                                       isDebriefOpen: $isOpen,
                                       isURLOpen: $openedURL,
                                       articleID: $onOpenArticleUrl)
                }
                
                ForEach(debriefDisplayInfo.randomArticles) { article in
                    DebriefArticleView(header: "Top Articles of the Week",
                                       article: article,
                                       isDebriefOpen: $isOpen,
                                       isURLOpen: $openedURL,
                                       articleID: $onOpenArticleUrl)
                }
                
                VStack {
                    Header("See You Next Week!", .center)
                        .padding(.top, 24)
                    
                    VStack {
                        Image.volume.logo
                            .resizable()
                            .frame(width: 245, height: 75)
                        Text("Stay updated with Cornell student publications, all in one place")
                            .font(.newYorkRegular(size: 16))
                    }
                    .padding(.top, 200)
                    
                    Button {
                        isOpen = false
                    } label: {
                        Text("Continue to Volume")
                            .foregroundColor(.volume.orange)
                            .font(.helveticaBold(size: 16))
                    }
                }
                .padding(.horizontal, 50)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
    
    var body: some View {
        VStack {
            switch state {
            case .loading:
                BigReadArticleRow.Skeleton() // TODO: This is until we have a SkeletonView for WeeklyDebrief
            case .reloading(let debriefDisplayInfo):
                makeView(debriefDisplayInfo: debriefDisplayInfo)
            case .results(let debriefDisplayInfo):
                makeView(debriefDisplayInfo: debriefDisplayInfo)
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .gray
            UIPageControl.appearance().pageIndicatorTintColor = .lightGray
            fetchInfoFor(debrief: weeklyDebrief)
        }
        .onDisappear {
            UIPageControl.appearance().currentPageIndicatorTintColor = nil
            UIPageControl.appearance().pageIndicatorTintColor = nil
        }
    }
    
    // MARK: - Copying from BrowserView
    
    private func asyncPopulateDisplayInfo(recievedArticles: Int = 0, ids: [ArticleID], readNotRandom: Bool, displayInfo: WeeklyDebriefDisplayInfo, completion: @escaping (WeeklyDebriefDisplayInfo) -> ()) {
        if recievedArticles == ids.count {
            completion(displayInfo)
            return
        }
        
        cancellableArticleQuery = Network.shared.publisher(for: GetArticleByIdQuery(id: ids[recievedArticles]))
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: article retrieval failed for \(ids[recievedArticles]): ", error.localizedDescription)
                }
            }
            receiveValue: { articleFields in
                let article = Article(from: articleFields.article!.fragments.articleFields)
                
                var newDisplayInfo = displayInfo
                
                if readNotRandom {
                    newDisplayInfo.readArticles.append(article)
                } else {
                    newDisplayInfo.randomArticles.append(article)
                }
                
                asyncPopulateDisplayInfo(recievedArticles: recievedArticles + 1, ids: ids, readNotRandom: readNotRandom, displayInfo: newDisplayInfo, completion: completion)
            }
    }
    
    private func fetchInfoFor(debrief: WeeklyDebrief) {
        let startingDisplayInfo = WeeklyDebriefDisplayInfo(
            creationDate: debrief.creationDate,
            expirationDate: debrief.expirationDate,
            numShoutouts: debrief.numShoutouts,
            numReadArticles: debrief.numReadArticles,
            numBookmarkedArticles: debrief.numBookmarkedArticles,
            readArticles: [],
            randomArticles: [])
        
        asyncPopulateDisplayInfo(ids: debrief.readArticleIDs, readNotRandom: true, displayInfo: startingDisplayInfo) {
            asyncPopulateDisplayInfo(ids: debrief.randomArticleIDs, readNotRandom: false, displayInfo: $0) {
                state = .results($0)
            }
        }
    }
    
    /**
     * Creates a date string for the past week
     */
    private func getWeekString() -> String {
        return "Your weekly debrief, \(weeklyDebrief.creationDate.simpleString) - \(weeklyDebrief.expirationDate.simpleString)"
    }
}

extension WeeklyDebriefView {
    struct WeeklyDebriefDisplayInfo {
        var creationDate: Date
        var expirationDate: Date
        var numShoutouts: Int
        var numReadArticles: Int
        var numBookmarkedArticles: Int
        var readArticles: [Article]
        var randomArticles: [Article]
    }
}
