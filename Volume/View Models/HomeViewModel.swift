//
//  HomeViewModel.swift
//  Volume
//
//  Created by Hanzheng Li on 10/26/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension HomeView {
    @MainActor class ViewModel: ObservableObject {
        typealias ArticlesResultPublisher = Publishers.Map<OperationPublisher<GetArticlesByPublicationSlugsQuery.Data>, [ArticleFields]>
        typealias DataState<T> = MainView.TabState<T>

        private struct Constants {
            static let pageSize: Double = 10
            static let trendingArticleLimit: Double = 7
        }

        var networkState: NetworkState?
        var userData: UserData?

        @Published var trendingArticles: DataState<[Article]> = .loading
        @Published var weeklyDebrief: DataState<WeeklyDebrief?> = .loading
        @Published var followedArticles: DataState<[Article]> = .loading
        @Published var unfollowedArticles: DataState<[Article]> = .loading
        @Published var hasMoreFollowedArticlePages = true
        @Published var hasMoreUnfollowedArticlePages = true
        @Published var isWeeklyDebriefOpen: Bool = false
        @Published var deeplinkID: String? = nil
        @Published var openArticleFromDeeplink: Bool = false

        private var publicationSlugs: MainView.TabState<[String]> = .loading
        private var queryBag = Set<AnyCancellable>()

        /// Returns empty list if still loading
        private var loadedPublicationSlugs: [String] {
            switch publicationSlugs {
            case .loading:
                return []
            case .results(let slugs), .reloading(let slugs):
                return slugs
            }
        }

        func setupEnvironment(networkState: NetworkState, userData: UserData) {
            self.networkState = networkState
            self.userData = userData
        }

        var followedPublicationSlugs: [String] {
            userData?.followedPublicationSlugs ?? []
        }

        var hasFollowedPublications: Bool {
            !followedPublicationSlugs.isEmpty
        }

        var disableScrolling: Bool {
            switch trendingArticles {
            case .loading:
                return true
            default:
                return false
            }
        }

        // MARK: Requests

        func fetchContent() {
            trendingArticles = .loading
            followedArticles = .loading
            weeklyDebrief = .loading
            unfollowedArticles = .loading

            fetchTrendingArticles()
            fetchWeeklyDebrief()
            fetchFirstPage()
        }

        func fetchWeeklyDebrief() {
            func fetch() {
                guard let uuid = userData?.uuid else {
                    #if DEBUG
                    print("Error: received nil UUID from UserData")
                    #endif
                    return
                }

                Network.shared.publisher(for: GetWeeklyDebriefQuery(uuid: uuid))
                    .map(\.user?.weeklyDebrief)
                    .sink { [weak self] completion in
                        self?.networkState?.handleCompletion(screen: .home, completion)
                    } receiveValue: { [weak self] weeklyDebriefFields in
                        guard let weeklyDebriefFields else {
                            #if DEBUG
                            print("Error: GetWeeklyDebrief failed on HomeView: field \"weeklyDebrief\" is nil.")
                            #endif
                            self?.weeklyDebrief = .results(nil)
                            return
                        }

                        let weeklyDebrief = WeeklyDebrief(from: weeklyDebriefFields)
                        self?.userData?.weeklyDebrief = weeklyDebrief
                        self?.weeklyDebrief = .results(weeklyDebrief)
                        self?.isWeeklyDebriefOpen = true
                    }
                    .store(in: &queryBag)
            }

            if let cachedWeeklyDebrief = userData?.weeklyDebrief {
                if cachedWeeklyDebrief.expirationDate < Date() {
                    // Cached WD expired, query new one
                    fetch()
                } else {
                    // Cached WD still fresh, stop loading state
                    weeklyDebrief = .results(cachedWeeklyDebrief)
                }
            } else {
                // No existing WD, query new one
                fetch()
            }
        }

        func fetchTrendingArticles() {
            // TODO: filter trending articles from feed?
            Network.shared.publisher(for: GetTrendingArticlesQuery(limit: Constants.trendingArticleLimit))
                .map { $0.articles.map(\.fragments.articleFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .home, completion)
                } receiveValue: { articleFieldsList in
                    self.trendingArticles = .results([Article](articleFieldsList))
                }
                .store(in: &queryBag)
        }

        func fetchFirstPage() {
            Network.shared.publisher(for: GetAllPublicationSlugsQuery())
                .map { $0.publications.map(\.slug) }
                .flatMap { slugs -> ArticlesResultPublisher in
                    self.publicationSlugs = .results(slugs)
                    let query = GetArticlesByPublicationSlugsQuery(slugs: self.followedPublicationSlugs, limit: Constants.pageSize)
                    return Network.shared.publisher(for: query)
                        .map { $0.articles.map(\.fragments.articleFields) }
                }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .home, completion)
                } receiveValue: { [weak self] articleFields in
                    self?.updateArticles(followed: true, with: articleFields)
                }
                .store(in: &queryBag)
        }

        func fetchPage(followed: Bool) {
            let slugs = followed ? followedPublicationSlugs : loadedPublicationSlugs
            Network.shared
                .publisher(for: GetArticlesByPublicationSlugsQuery(slugs: slugs, limit: Constants.pageSize, offset: offset(for: followed ? followedArticles : unfollowedArticles)))
                .map { $0.articles.map(\.fragments.articleFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .home, completion)
                } receiveValue: { [weak self] articleFields in
                    self?.updateArticles(followed: followed, with: articleFields)
                }
                .store(in: &queryBag)
        }

        // MARK: Deeplink

        func handleURL(_ url: URL) {
            if url.isDeeplink, let id = url.parameters["id"] {
                deeplinkID = id
                openArticleFromDeeplink = true
            }
        }

        // MARK: Helpers

        private func offset(for articles: MainView.TabState<[Article]>) -> Double {
            switch articles {
            case .loading, .reloading:
                return 0
            case .results(let articles):
                return Double(articles.count)
            }
        }

        private func updateArticles(followed: Bool, with articleFields: [ArticleFields]) {
            let newArticles = [Article](articleFields)

            switch followed ? followedArticles : unfollowedArticles {
            case .loading, .reloading:
                if followed {
                    followedArticles = .results(newArticles)
                } else {
                    unfollowedArticles = .results(newArticles)
                }
            case .results(let articles):
                if followed {
                    followedArticles = .results(articles + newArticles)
                } else {
                    unfollowedArticles = .results(articles + newArticles)
                }
            }

            if newArticles.count < Int(Constants.pageSize) {
                if followed {
                    hasMoreFollowedArticlePages = false
                } else {
                    hasMoreUnfollowedArticlePages = false
                }
            }
        }
    }
}
