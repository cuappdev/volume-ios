////
////  HomeViewModel.swift
////  Volume
////
////  Created by Hanzheng Li on 10/26/22.
////  Copyright © 2022 Cornell AppDev. All rights reserved.
////
//
//import Combine
//import SwiftUI
//
//extension HomeView {
//    @MainActor class ViewModel: ObservableObject {
//        typealias ArticlesResultPublisher = Publishers.Map<OperationPublisher<GetArticlesByPublicationSlugsQuery.Data>, [ArticleFields]>
//
//        private struct Constants {
//            static let pageSize: Double = 10
//            static let trendingArticleLimit: Double = 7
//        }
//
//        var networkState: NetworkState?
//        var userData: UserData?
//
//        @Published var trendingArticles: [Article]? = nil
//        @Published var weeklyDebrief: WeeklyDebrief? = nil
//        @Published var followedArticles: [Article]? = nil
//        @Published var unfollowedArticles: [Article]? = nil
//
//        @Published var hasMoreFollowedArticlePages = true
//        @Published var hasMoreUnfollowedArticlePages = true
//        @Published var isWeeklyDebriefOpen: Bool = false
//        @Published var deeplinkID: String? = nil
//        @Published var openArticleFromDeeplink: Bool = false
//        @Published var searchState: SearchView.SearchState = .searching
//        @Published var searchText: String = ""
//
//        private var publicationSlugs: [String]? = nil
//        private var queryBag = Set<AnyCancellable>()
//
//        func setupEnvironment(networkState: NetworkState, userData: UserData) {
//            if self.networkState == nil || self.userData == nil {
//                self.networkState = networkState
//                self.userData = userData
//            }
//        }
//
//        private var followedPublicationSlugs: [String] {
//            userData?.followedPublicationSlugs ?? []
//        }
//
//        private var unfollowedPublicationSlugs: [String] {
//            publicationSlugs?.filter { slug -> Bool in
//                !followedPublicationSlugs.contains(slug)
//            } ?? []
//        }
//
//        var hasFollowedPublications: Bool {
//            !followedPublicationSlugs.isEmpty
//        }
//
//        var disableScrolling: Bool {
//            trendingArticles == .none
//        }
//
//        // MARK: Requests
//
//        func fetchContent() async {
//            fetchTrendingArticles()
//            fetchWeeklyDebrief()
//            if followedArticles == nil {
//                await fetchFirstPage()
//            }
//        }
//
//        func refreshContent() async {
//            Network.shared.clearCache()
//            queryBag.removeAll()
//
//            trendingArticles = nil
//            followedArticles = nil
//            weeklyDebrief = nil
//            unfollowedArticles = nil
//            publicationSlugs = nil
//
//            await fetchContent()
//        }
//
//        func fetchTrendingArticles() {
//            Network.shared.publisher(for: GetTrendingArticlesQuery(limit: Constants.trendingArticleLimit))
//                .map { $0.articles.map(\.fragments.articleFields) }
//                .sink { [weak self] completion in
//                    self?.networkState?.handleCompletion(screen: .home, completion)
//                } receiveValue: { [weak self] articleFieldsList in
//                    self?.trendingArticles = [Article](articleFieldsList)
//                }
//                .store(in: &queryBag)
//        }
//
//        func fetchWeeklyDebrief() {
//            func fetch() {
//                guard let uuid = userData?.uuid else {
//                    #if DEBUG
//                    print("Error: received nil UUID from UserData")
//                    #endif
//                    return
//                }
//
//                Network.shared.publisher(for: GetWeeklyDebriefQuery(uuid: uuid))
//                    .map(\.user?.weeklyDebrief)
//                    .sink { [weak self] completion in
//                        self?.networkState?.handleCompletion(screen: .home, completion)
//                    } receiveValue: { [weak self] weeklyDebriefFields in
//                        guard let weeklyDebriefFields else {
//                            #if DEBUG
//                            print("Error: GetWeeklyDebrief failed on HomeView: field \"weeklyDebrief\" is nil.")
//                            #endif
//                            self?.weeklyDebrief = nil
//                            return
//                        }
//
//                        let weeklyDebrief = WeeklyDebrief(from: weeklyDebriefFields)
//                        self?.userData?.weeklyDebrief = weeklyDebrief
//                        self?.weeklyDebrief = weeklyDebrief
//                        self?.isWeeklyDebriefOpen = !weeklyDebrief.isExpired
//                    }
//                    .store(in: &queryBag)
//            }
//
//            if let cachedWeeklyDebrief = userData?.weeklyDebrief {
//                if cachedWeeklyDebrief.isExpired {
//                    // Cached WD expired, query new one
//                    fetch()
//                } else {
//                    // Cached WD still fresh, stop loading state
//                    weeklyDebrief = cachedWeeklyDebrief
//                }
//            } else {
//                // No existing WD, query new one
//                fetch()
//            }
//        }
//
//        func fetchFirstPage() async {
//            await withCheckedContinuation { continuation in
//                Network.shared.publisher(for: GetAllPublicationSlugsQuery())
//                    .map { $0.publications.map(\.slug) }
//                    .flatMap { [weak self] slugs -> ArticlesResultPublisher in
//                        self?.publicationSlugs = slugs
//                        let query = GetArticlesByPublicationSlugsQuery(
//                            slugs: self?.followedPublicationSlugs ?? [],
//                            limit: Constants.pageSize
//                        )
//                        return Network.shared.publisher(for: query)
//                            .map { $0.articles.map(\.fragments.articleFields) }
//                    }
//                    .sink { [weak self] completion in
//                        self?.networkState?.handleCompletion(screen: .home, completion)
//                    } receiveValue: { [weak self] articleFields in
//                        self?.updateArticles(followed: true, with: articleFields)
//                        continuation.resume()
//                    }
//                    .store(in: &queryBag)
//            }
//        }
//
//        func fetchPage(followed: Bool) {
//            let slugs = followed ? followedPublicationSlugs : unfollowedPublicationSlugs
//            Network.shared
//                .publisher(
//                    for: GetArticlesByPublicationSlugsQuery(
//                        slugs: slugs,
//                        limit: Constants.pageSize,
//                        offset: offset(for: followed ? followedArticles : unfollowedArticles)
//                    )
//                )
//                .map { $0.articles.map(\.fragments.articleFields) }
//                .sink { [weak self] completion in
//                    self?.networkState?.handleCompletion(screen: .home, completion)
//                } receiveValue: { [weak self] articleFields in
//                    self?.updateArticles(followed: followed, with: articleFields)
//                }
//                .store(in: &queryBag)
//        }
//
//        // MARK: Deeplink
//
//        func handleURL(_ url: URL) {
//            if url.isDeeplink,
//               url.contentType == .article,
//               let id = url.parameters["id"] {
//                deeplinkID = id
//                openArticleFromDeeplink = true
//            }
//        }
//
//        // MARK: Helpers
//
//        private func offset(for articles: [Article]?) -> Double {
//            Double(articles?.count ?? 0)
//        }
//
//        private func updateArticles(followed: Bool, with articleFields: [ArticleFields]) {
//            let newArticles = [Article](articleFields)
//
//            switch followed ? followedArticles : unfollowedArticles {
//            case .none:
//                if followed {
//                    followedArticles = newArticles
//                } else {
//                    unfollowedArticles = newArticles
//                }
//            case .some(let articles):
//                if followed {
//                    followedArticles = articles + newArticles
//                } else {
//                    unfollowedArticles = articles + newArticles
//                }
//            }
//
//            if newArticles.count < Int(Constants.pageSize) {
//                if followed {
//                    hasMoreFollowedArticlePages = false
//                } else {
//                    hasMoreUnfollowedArticlePages = false
//                }
//            }
//        }
//    }
//}
