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
    
    @Binding private var openedURL: Bool
    @Binding private var onOpenArticleUrl: String?
    
    let initType: WeeklyDebriefViewInitType
    
    @State private var cancellableArticleQuery: AnyCancellable?
    @State private var cancellableReadMutation: AnyCancellable?
    @State private var cancellableShoutoutMutation: AnyCancellable?
    @State private var state: WeeklyDebriefViewState<WeeklyDebriefDisplayInfo> = .loading
    

    init(openedWeeklyDebrief: Binding<Bool>, urlIsOpen: Binding<Bool>, articleURL: Binding<String?>, weeklyDebrief: WeeklyDebrief) {
        _isOpen = openedWeeklyDebrief
        self.weeklyDebrief = weeklyDebrief
        
        self.initType = .fetchRequired
        
        _openedURL = urlIsOpen
        _onOpenArticleUrl = articleURL
        
    }
    
    var body: some View {
        VStack {
            switch state {
            case .loading:
                BigReadArticleRow.Skeleton() // This is until we have a SkeletonView for WeeklyDebrief
            case .results(let debriefDisplayInfo):
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
                        Text(getWeekString())
                            .padding([.top, .bottom], 32)
                            .font(.newYorkMedium(size: 16))
                        Divider()
                            .frame(width: 100)
                            .padding(.bottom, 48)
                        VStack(spacing: 24, content: {
                            HStack {
                                Text("In the past week, you...")
                                    .font(.newYorkRegular(size: 16))
                                Spacer()
                            }
                            StatisticView(image: "volume", leftText: "read", number: debriefDisplayInfo.numReadArticles, rightText: "articles")
                            StatisticView(image: "shout-out", leftText: "gave", number: debriefDisplayInfo.numShoutouts, rightText: "shout-outs")
                            StatisticView(image: "bookmark", leftText: "bookmarked", number: debriefDisplayInfo.numBookmarkedArticles, rightText: "articles")
                            HStack {
                                Text("You were among the top ")
                                    .font(.newYorkRegular(size: 16)) +
                                Text("10% ")
                                    .font(.newYorkMedium(size: 36))
                                    .foregroundColor(Color.volume.orange) +
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
                        })
                            .padding([.leading, .trailing], 48)
                        Spacer()
                    }
                    ForEach(debriefDisplayInfo.readArticles) { article in
                        DebriefArticleView(header: "Share What You Read",
                                           article: article,
                                           debriefViewIsOpen: $isOpen,
                                           didOpenURL: $openedURL,
                                           showArticle: $onOpenArticleUrl)
                    }
                    ForEach(debriefDisplayInfo.randomArticles) { article in
                        DebriefArticleView(header: "Top Articles of the Week",
                                           article: article,
                                           debriefViewIsOpen: $isOpen,
                                           didOpenURL: $openedURL,
                                           showArticle: $onOpenArticleUrl)
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
                    .padding([.leading, .trailing], 50)
                }
                .tabViewStyle(PageTabViewStyle())
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .gray
            UIPageControl.appearance().pageIndicatorTintColor = .lightGray
            
            if let uuid = userData.uuid {
                fetchWeeklyDebrief(for: uuid)
            }
            
        }
        .onDisappear {
            UIPageControl.appearance().currentPageIndicatorTintColor = nil
            UIPageControl.appearance().pageIndicatorTintColor = nil
        }
    }
    
    
    // MARK: - Copying from BrowserView
    
    private func fetchWeeklyDebrief(for uuid: String) {
        state = .loading
        cancellableArticleQuery = Network.shared.publisher(for: GetWeeklyDebriefQuery(uuid: uuid))
            .sink { completion in
                if case let .failure(_) = completion {
                    // We are assuming this case won't occur
                    print("Debrief Requested but not Acquired")
                }
            }
            receiveValue: { debriefData in
                let debrief = WeeklyDebrief(from: debriefData.user!.weeklyDebrief!)
                fetchInfoFor(debrief: debrief)
            }
    }
    
    private func fetchInfoFor(debrief: WeeklyDebrief) {
        
        var debriefDisplayInfo = WeeklyDebriefDisplayInfo(
            creationDate: debrief.creationDate,
            expirationDate: debrief.expirationDate,
            numShoutouts: debrief.numShoutouts,
            numReadArticles: debrief.numReadArticles,
            numBookmarkedArticles: debrief.numBookmarkedArticles,
            readArticles: [],
            randomArticles: [])
        
        func asyncPopulateDisplayInfo(recievedArticles: Int = 0, ids: [ArticleID], readNotRandom: Bool, completion: @escaping () -> ()) {
            if recievedArticles == ids.count {
                completion()
                return
            }
            
            cancellableArticleQuery = Network.shared.publisher(for: GetArticleByIdQuery(id: ids[recievedArticles]))
                .sink { completion in
                    if case let .failure(error) = completion {
                        print(error.localizedDescription)
                    }
                }
                receiveValue: { articleFields in
                    let article = Article(from: articleFields.article!.fragments.articleFields)
                    
                    if readNotRandom {
                        debriefDisplayInfo.readArticles.append(article)
                    } else {
                        debriefDisplayInfo.randomArticles.append(article)
                    }
                    
                    asyncPopulateDisplayInfo(recievedArticles: recievedArticles + 1, ids: ids, readNotRandom: readNotRandom, completion: completion)
                }
        }
        
        asyncPopulateDisplayInfo(ids: debrief.readArticleIDs, readNotRandom: true) {
            asyncPopulateDisplayInfo(ids: debrief.randomArticleIDs, readNotRandom: false) {
                state = .results(debriefDisplayInfo)
            }
        }
        
    }
    
    /**
     * Creates a date string for the past week
     */
    private func getWeekString() -> String {
        var message = "Your weekly debrief"
        
        if let firstDay = weeklyDebrief?.creationDate, let lastDay = weeklyDebrief?.expirationDate {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("M/dd")
            
            let firstString = formatter.string(from: firstDay)
            let lastString = formatter.string(from: lastDay)
            message.append(contentsOf: ", " + firstString + " - " + lastString)
        }
        
        return message
    }
    
}

extension WeeklyDebriefView {
    private enum WeeklyDebriefViewState<Result> {
        case loading, results(Result)
    }
    
    enum WeeklyDebriefViewInitType {
        case readyForDisplay(WeeklyDebrief), fetchRequired
    }
    
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
