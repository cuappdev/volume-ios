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

        private struct Constants {
            static let pageSize: Double = 10
        }

        var networkState: NetworkState?
        var userData: UserData?

        @Published var trendingArticles: MainView.TabState<[Article]> = .loading
        @Published var followedArticles: MainView.TabState<[Article]> = .loading
        @Published var unfollowedArticles: MainView.TabState<[Article]> = .loading
        @Published var hasMoreFollowedArticlePages = true
        @Published var hasMoreUnfollowedArticlePages = true

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

        func setup(networkState: NetworkState, userData: UserData) {
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

        func refreshContent() {
            trendingArticles = .loading
            followedArticles = .loading
            unfollowedArticles = .loading

            fetchTrendingArticles()
            fetchPage()
        }

        func fetchTrendingArticles() {
            Network.shared.publisher(for: GetTrendingArticlesQuery(limit: 7))
                .map { $0.articles.map(\.fragments.articleFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .home, completion)
                } receiveValue: { articleFieldsList in
                    self.trendingArticles = .results([Article](articleFieldsList))
                }
                .store(in: &queryBag)
        }

        func fetchPage() {
            if offset(for: followedArticles) == 0 {
                // Get first page
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
                        self?.updateArticles(with: articleFields)
                    }
                    .store(in: &queryBag)
            } else {
                let slugs = hasMoreFollowedArticlePages ? followedPublicationSlugs : loadedPublicationSlugs
                Network.shared
                    .publisher(for: GetArticlesByPublicationSlugsQuery(slugs: slugs, limit: Constants.pageSize, offset: offset(for: hasMoreFollowedArticlePages ? followedArticles : unfollowedArticles)))
                    .map { $0.articles.map(\.fragments.articleFields) }
                    .sink { [weak self] completion in
                        self?.networkState?.handleCompletion(screen: .home, completion)
                    } receiveValue: { [weak self] articleFields in
                        self?.updateArticles(with: articleFields)
                    }
                    .store(in: &queryBag)
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

        private func updateArticles(with articleFields: [ArticleFields]) {
            let newArticles = [Article](articleFields)

            switch hasMoreFollowedArticlePages ? followedArticles : unfollowedArticles {
            case .loading, .reloading:
                if hasMoreFollowedArticlePages {
                    followedArticles = .results(newArticles)
                } else {
                    unfollowedArticles = .results(newArticles)
                }
            case .results(let articles):
                if hasMoreFollowedArticlePages {
                    followedArticles = .results(articles + newArticles)
                } else {
                    unfollowedArticles = .results(articles + newArticles)
                }
            }

            if newArticles.count < Int(Constants.pageSize) {
                if hasMoreFollowedArticlePages {
                    hasMoreFollowedArticlePages = false
                } else {
                    hasMoreUnfollowedArticlePages = false
                }
            }
        }
    }
}
