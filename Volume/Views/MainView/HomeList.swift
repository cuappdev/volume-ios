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
    @State private var sectionStates: SectionStates = (.loading, .loading, .loading, .loading)
    @State private var sectionQueries: SectionQueries = (nil, nil, nil)
    @State private var openedUrl = false
    @State private var onOpenArticleUrl: String?
    @State private var isWeeklyDebriefOpen = false
    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var notifications: Notifications
    @EnvironmentObject private var userData: UserData

    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = UIColor(Color.volume.backgroundGray)

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
    }

    private func fetchContent(_ done: @escaping () -> Void = { }) {
        guard sectionStates.trendingArticles.isLoading || sectionStates.weeklyDebrief.isLoading || sectionStates.followedArticles.isLoading || sectionStates.otherArticles.isLoading else { return }
        
        fetchTrendingArticles(done)
        fetchFeedArticles()
        
        if let expirationDate = userData.weeklyDebrief?.expirationDate {
            if expirationDate < Date() {
                // Cached WD expired, query new one
                fetchWeeklyDebrief()
            }
        } else {
            // No existing WD, query new one
            fetchWeeklyDebrief()
        }
    }
    
    private func fetchTrendingArticles(_ done: @escaping () -> Void = { }) {
        sectionQueries.trendingArticles = Network.shared.publisher(for: GetTrendingArticlesQuery(limit: 7))
            .map { $0.articles.map(\.fragments.articleFields) }
            .sink { completion in
                networkState.handleCompletion(screen: .homeList, completion)
            } receiveValue: { articleFields in
                let trendingArticles = [Article](articleFields)
                
                withAnimation(.linear(duration: 0.1)) {
                    sectionStates.trendingArticles = .results(trendingArticles)
                }
                
                // Filter trending articles if feed articles request returned first
                if case let .results(followedArticles) = sectionStates.followedArticles {
                    let followedArticlesWithoutTrending = followedArticles.filter { article in
                        !trendingArticles.contains { $0.id == article.id }
                    }
                    withAnimation(.linear(duration: 0.1)) {
                        sectionStates.followedArticles = .results(followedArticlesWithoutTrending)
                    }
                }
                
                if case let .results(otherArticles) = sectionStates.otherArticles {
                    let otherArticlesWithoutTrending = otherArticles.filter { article in
                        !trendingArticles.contains { $0.id == article.id }
                    }
                    withAnimation(.linear(duration: 0.1)) {
                        sectionStates.otherArticles = .results(otherArticlesWithoutTrending)
                    }
                }
                
                done()
            }
    }
    
    private func fetchFeedArticles() {
        sectionQueries.feedArticles = Network.shared.publisher(for: GetAllPublicationIDsQuery())
            .map { $0.publications.map(\.id) }
            .flatMap { publicationIDs -> ResultsPublisher in
                let followedQuery = Network.shared.publisher(for: GetArticlesByPublicationIDsQuery(ids: userData.followedPublicationIDs))
                    .map { $0.articles.map(\.fragments.articleFields) }
                    .collect()

                let morePublicationIDs = publicationIDs.filter { !userData.followedPublicationIDs.contains($0) }

                let otherQuery = Network.shared.publisher(for: GetArticlesByPublicationIDsQuery(ids: morePublicationIDs))
                    .map { $0.articles.map(\.fragments.articleFields) }
                
                return Publishers.Zip(followedQuery, otherQuery)
            }
            .sink { completion in
                networkState.handleCompletion(screen: .homeList, completion)
            } receiveValue: { followed, other in
                // Exclude trending articles from following articles
                // Take up to 20 followed articles, sorted in descending chronological order
                let followedArticles = Array(followed.joined().filter { article in
                    if case let .results(trendingArticles) = sectionStates.trendingArticles {
                        return !trendingArticles.contains { $0.id == article.id }
                    } else { return false }
                }).sorted(by: { $0.date > $1.date }).prefix(20)
                
                // Exclude followed and trending articles from other articles
                let otherArticles = Array(other.filter { article in
                    if case let .results(trendingArticles) = sectionStates.trendingArticles {
                        return !trendingArticles.contains { $0.id == article.id }
                    } else {
                        return !followedArticles.contains { $0.id == article.id }
                    }
                }).sorted(by: { $0.date > $1.date }).prefix(45)
                
                withAnimation(.linear(duration: 0.1)) {
                    sectionStates.followedArticles = .results([Article](followedArticles))
                    sectionStates.otherArticles = .results([Article](otherArticles))
                }
            }
    }
  
    private var isFollowingPublications: Bool {
        switch sectionStates.followedArticles {
        case .loading:
            return userData.followedPublicationIDs.count > 0
        case .reloading(let results), .results(let results):
            return results.count > 0
        }
    }
    
    private func fetchWeeklyDebrief() {
        guard let uuid = userData.uuid else {
            print("Error: received nil UUID from UserData")
            return
        }
        
        sectionQueries.weeklyDebrief = Network.shared.publisher(for: GetWeeklyDebriefQuery(uuid: uuid))
            .map(\.user?.weeklyDebrief)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: GetWeeklyDebriefQuery failed on HomeList: \(error.localizedDescription)")
                }
            } receiveValue: { weeklyDebrief in
                if let weeklyDebrief = weeklyDebrief {
                    let weeklyDebriefObject = WeeklyDebrief(from: weeklyDebrief)
                    userData.weeklyDebrief = weeklyDebriefObject
                    sectionStates.weeklyDebrief = .results(weeklyDebriefObject)
                    isWeeklyDebriefOpen = true
                } else {
                    print("Error: GetWeeklyDebrief failed on HomeList: field \"weeklyDebrief\" is nil.")
                    sectionStates.weeklyDebrief = .results(nil)
                }
            }
    }
    
    private var trendingArticlesSection: some View {
        Group {
            Header("The Big Read")
                .padding([.top, .horizontal])
            ScrollView(.horizontal, showsIndicators: false) {
                switch sectionStates.trendingArticles {
                case .loading:
                    HStack(spacing: 24) {
                        ForEach(0..<2) { _ in
                            BigReadArticleRow.Skeleton()
                        }
                    }
                case .reloading(let articles), .results(let articles):
                    HStack(spacing: 24) {
                        ForEach(articles) { article in
                            NavigationLink(destination: BrowserView(initType: .readyForDisplay(article), navigationSource: .trendingArticles)) {
                                BigReadArticleRow(article: article)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var weeklyDebriefButton: some View {
        Group {
            switch sectionStates.weeklyDebrief {
            case .loading:
                SkeletonView()
            case .reloading, .results:
                Button {
                    isWeeklyDebriefOpen = true
                } label: {
                    ZStack(alignment: .leading) {
                        Image.volume.weeklyDebriefCurves
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        HStack(alignment: .top) {
                            Text("Your\nWeekly\nDebrief")
                                .font(.newYorkRegular(size: 18))
                                .foregroundColor(.volume.orange)
                                .padding(.leading)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image.volume.rightArrow
                                .padding(.trailing)
                        }
                    }
                }
            }
        }
        .frame(height: 92)
        .padding(.horizontal)
        .shadow(color: .volume.shadowBlack, radius: 5, x: 0, y: 0)
    }
    
    var followedArticlesSection: some View {
        Group {
            Header("Following")
                .padding(.horizontal)
            switch sectionStates.followedArticles {
            case .loading:
                let skeletonCount = userData.followedPublicationIDs.isEmpty ? 0 : 5
                
                ForEach(0..<skeletonCount, id: \.self) { _ in
                    ArticleRow.Skeleton()
                        .padding(.horizontal)
                }
                
                if userData.followedPublicationIDs.isEmpty {
                    Spacer()
                    
                    VolumeMessage(message: .noFollowingHome, largeFont: false, fullWidth: false)
                        .padding(.top, 25)
                        .padding(.bottom, -5)
                }
            case .reloading(let articles), .results(let articles):
                ForEach(articles) { article in
                    NavigationLink(destination: BrowserView(initType: .readyForDisplay(article), navigationSource: .followingArticles)) {
                        ArticleRow(article: article, navigationSource: .followingArticles)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                VolumeMessage(message: articles.count > 0 ? .upToDate : .noFollowingHome, largeFont: false, fullWidth: false)
                    .padding(.top, 25)
                    .padding(.bottom, -5)
            }
        }
    }
    
    var otherArticlesSection: some View {
        Group {
            Header("Other Articles").padding()
            switch sectionStates.otherArticles {
            case .loading:
                ForEach(0..<5) { _ in
                    ArticleRow.Skeleton()
                        .padding(.horizontal)
                }
            case .reloading(let articles), .results(let articles):
                ForEach(articles) { article in
                    NavigationLink(destination: BrowserView(initType: .readyForDisplay(article), navigationSource: .otherArticles)) {
                        ArticleRow(article: article, navigationSource: .otherArticles)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }

    var body: some View {
        RefreshableScrollView(onRefresh: { done in
            // TODO: add weekly debrief to this switch when the request stops breaking
            if case let .results(articles) = sectionStates.trendingArticles {
                sectionStates.trendingArticles = .reloading(articles)
            }
            
            sectionStates.followedArticles = .loading
            sectionStates.otherArticles = .loading
            
            fetchContent(done)
        }) {
            VStack(spacing: 20) {
                trendingArticlesSection
                if let _ = userData.weeklyDebrief {
                    // Reserve space for weekly debrief if user has had one before
                    weeklyDebriefButton
                }
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
        .disabled(sectionStates.trendingArticles.shouldDisableScroll)
        .padding(.top)
        .background(Color.volume.backgroundGray)
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                Image.volume.logo
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
                WeeklyDebriefView(openedWeeklyDebrief: $isWeeklyDebriefOpen,
                                  urlIsOpen: $openedUrl,
                                  articleURL: $onOpenArticleUrl,
                                  weeklyDebrief: weeklyDebrief)
            }
        }
    }
}

extension HomeList {
    typealias ResultsPublisher =
        Publishers.Zip<
            Publishers.Collect<Publishers.Map<OperationPublisher<GetArticlesByPublicationIDsQuery.Data>, [ArticleFields]>>,
            Publishers.Map<OperationPublisher<GetArticlesByPublicationIDsQuery.Data>, [ArticleFields]>
        >
    
    typealias SectionStates = (
        trendingArticles: MainView.TabState<[Article]>,
        weeklyDebrief: MainView.TabState<WeeklyDebrief?>,
        followedArticles: MainView.TabState<[Article]>,
        otherArticles: MainView.TabState<[Article]>
    )
    
    typealias SectionQueries = (
        trendingArticles: AnyCancellable?,
        weeklyDebrief: AnyCancellable?,
        // Same query receives followed articles & other articles
        feedArticles: AnyCancellable?
    )
}

//struct HomeList_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeList()
//    }
//}
