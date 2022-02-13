//
//  HomeList.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

struct HomeList: View {
    @State private var cancellableListQuery: AnyCancellable?
    @State private var cancellableWeeklyDebriefQuery: AnyCancellable?
    @State private var state: MainView.TabState<Results> = .loading
    @State private var openedUrl = false
    @State private var onOpenArticleUrl: String?
    @State private var isWeeklyDebriefOpen = false
    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var notifications: Notifications
    @EnvironmentObject private var userData: UserData

    private func fetchContent(_ done: @escaping () -> Void = { }) {
        guard state.isLoading else { return }

        cancellableListQuery = Network.shared.publisher(for: GetAllPublicationIDsQuery())
            .map { $0.publications.map(\.id) }
            .flatMap { publicationIDs -> ResultsPublisher in
                let trendingQuery = Network.shared.publisher(for: GetTrendingArticlesQuery(limit: 7))
                    .map { $0.articles.map(\.fragments.articleFields) }

                let followedQuery = Network.shared.publisher(for: GetArticlesByPublicationIDsQuery(ids: userData.followedPublicationIDs))
                    .map { $0.articles.map(\.fragments.articleFields) }
                    .collect()

                let morePublicationIDs = publicationIDs.filter { !userData.followedPublicationIDs.contains($0) }

                let otherQuery = Network.shared.publisher(for: GetArticlesByPublicationIDsQuery(ids: morePublicationIDs))
                    .map { $0.articles.map(\.fragments.articleFields) }
                
                return Publishers.Zip3(trendingQuery, followedQuery, otherQuery)
            }
            .sink { completion in
                networkState.handleCompletion(screen: .homeList, completion)
            } receiveValue: { (trendingArticles, followed, other) in
                // Exclude trending articles from following articles
                // Take up to 20 followed articles, sorted in descending chronological order
                let followedArticles = Array(followed.joined().filter { article in
                    !trendingArticles.contains(where: { $0.id == article.id })
                }).sorted(by: { $0.date > $1.date }).prefix(20)
                // Exclude followed and trending articles from other articles
                let otherArticles = Array(other.filter { article in
                    !(followedArticles.contains(where: { $0.id == article.id })
                        || trendingArticles.contains(where: { $0.id == article.id }))
                }).sorted(by: { $0.date > $1.date }).prefix(45)
                
                done()
                
                withAnimation(.linear(duration: 0.1)) {
                    state = .results((
                        trendingArticles: [Article](trendingArticles),
                        followedArticles: [Article](followedArticles),
                        otherArticles: [Article](otherArticles)
                    ))
                }
            }
        
        if let expirationDate = userData.weeklyDebrief?.expirationDate {
            if expirationDate < Date() {
                // cached WD expired, query new one
                fetchWeeklyDebrief()
            }
        } else {
            // no existing WD, query new one
            fetchWeeklyDebrief()
        }
    }
    
    private func fetchWeeklyDebrief() {
        guard let uuid = userData.uuid else {
            print("Error: received nil UUID from UserData")
            return
        }
        cancellableWeeklyDebriefQuery = Network.shared.publisher(for: GetWeeklyDebriefQuery(uuid: uuid))
            .map(\.user.weeklyDebrief)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { weeklyDebrief in
                userData.weeklyDebrief = WeeklyDebrief(from: weeklyDebrief)
                isWeeklyDebriefOpen = true
            }
    }
    
    private var trendingArticlesSection: some View {
        Group {
            Header("The Big Read")
                .padding([.top, .leading, .trailing])
            ScrollView(.horizontal, showsIndicators: false) {
                switch state {
                case .loading:
                    HStack(spacing: 24) {
                        ForEach(0..<2) { _ in
                            BigReadArticleRow.Skeleton()
                        }
                    }
                case .reloading(let results), .results(let results):
                    HStack(spacing: 24) {
                        ForEach(results.trendingArticles) { article in
                            BigReadArticleRow(article: article)
                        }
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }
    
    private var weeklyDebriefButton: some View {
        Group {
            switch state {
            case .loading:
                SkeletonView()
            case .reloading, .results:
                Button {
                    isWeeklyDebriefOpen = true
                    let _ = print("opening ")
                } label: {
                    ZStack(alignment: .leading) {
                        Image("weekly-debrief-curves")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        HStack(alignment: .top) {
                            Text("Your\nWeekly\nDebrief")
                                .font(.begumRegular(size: 18))
                                .foregroundColor(.volume.orange)
                                .padding([.leading])
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image("right-arrow")
                                .padding([.trailing])
                        }
                    }
                }
            }
        }
        .frame(height: 92)
        .padding([.horizontal])
        .shadow(color: .volume.shadowBlack, radius: 5, x: 0, y: 0)
    }
    
    var followedArticlesSection: some View {
        Group {
            Header("Following")
                .padding([.leading, .trailing])
            switch state {
            case .loading:
                ForEach(0..<5) { _ in
                    ArticleRow.Skeleton()
                        .padding([.leading, .trailing])
                }
            case .reloading(let results), .results(let results):
                ForEach(results.followedArticles) { article in
                    ArticleRow(article: article, navigationSource: .followingArticles)
                        .padding([.leading, .trailing])
                }
            }
            Spacer()
            VolumeMessage(message: .upToDate)
                .padding(.top, 25)
                .padding(.bottom, -5)
        }
    }
    
    var otherArticlesSection: some View {
        Group {
            Header("Other Articles").padding()
            switch state {
            case .loading:
                // will be off the page, so pointless to show anything
                Spacer().frame(height: 0)
            case .reloading(let results), .results(let results):
                ForEach(results.otherArticles) { article in
                    ArticleRow(article: article, navigationSource: .otherArticles)
                        .padding([.bottom, .leading, .trailing])
                }
            }
        }
    }

    var body: some View {
        RefreshableScrollView(onRefresh: { done in
            switch state {
            case .loading, .reloading:
                return
            case .results(let results):
                state = .reloading(results)
                fetchContent(done)
            }
        }) {
            VStack(spacing: 20) {
                trendingArticlesSection
                weeklyDebriefButton
                followedArticlesSection
                Spacer()
                otherArticlesSection
                // Invisible navigation link only opens if application is opened
                // through deeplink with valid article
                if let articleID = onOpenArticleUrl {
                    NavigationLink("", destination: BrowserView(initType: .fetchRequired(articleID), navigationSource: .morePublications), isActive: $openedUrl)
                }
            }
        }
        .disabled(state.shouldDisableScroll)
        .padding(.top)
        .background(Color.volume.backgroundGray)
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                Image("volume-logo")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchContent()
        }
        .onOpenURL { url in
            if url.isDeeplink {
                if let id = url.parameters["id"] {
                    onOpenArticleUrl = id
                    openedUrl = true
                }
            }
        }
        .onChange(of: notifications.isWeeklyDebriefOpen) { isOpen in
            isWeeklyDebriefOpen = isOpen
        }
        .sheet(isPresented: $isWeeklyDebriefOpen) {
            isWeeklyDebriefOpen = false
        } content: {
            if let weeklyDebrief = userData.weeklyDebrief {
                WeeklyDebriefView(openedWeeklyDebrief: $isWeeklyDebriefOpen, weeklyDebrief: weeklyDebrief)
            }
        }
    }
}

extension HomeList {
    typealias Results = (
        trendingArticles: [Article],
        followedArticles: [Article],
        otherArticles: [Article]
    )
    typealias ResultsPublisher =
        Publishers.Zip3<
            Publishers.Map<OperationPublisher<GetTrendingArticlesQuery.Data>,[ArticleFields]>,
            Publishers.Collect<Publishers.Map<OperationPublisher<GetArticlesByPublicationIDsQuery.Data>, [ArticleFields]>>,
            Publishers.Map<OperationPublisher<GetArticlesByPublicationIDsQuery.Data>, [ArticleFields]>
        >
}

struct HomeList_Previews: PreviewProvider {
    static var previews: some View {
        HomeList()
    }
}
