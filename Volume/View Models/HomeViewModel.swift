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
        @Published var hasMorePages = true

        private var publicationSlugs: MainView.TabState<[String]> = .loading
        private var queryBag = Set<AnyCancellable>()

        private var followedArticlesOffset: Double {
            switch followedArticles {
            case .loading:
                return 0
            case .results(let articles), .reloading(let articles):
                return Double(articles.count)
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

        func refreshContent(with completion: @escaping () -> Void) {
            guard case let .results(staleArticles) = trendingArticles else {
                completion()
                return
            }

            trendingArticles = .reloading(staleArticles)
            fetchTrendingArticles(with: completion)
        }

        func fetchTrendingArticles(with completion: @escaping () -> Void = { }) {
            Network.shared.publisher(for: GetTrendingArticlesQuery(limit: 7))
                .map { $0.articles.map(\.fragments.articleFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .home, completion)
                } receiveValue: { articleFieldsList in
                    self.trendingArticles = .results([Article](articleFieldsList))
                    completion()
                }
                .store(in: &queryBag)
        }

        func fetchPage() {
            if followedArticlesOffset == 0 {
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
                Network.shared
                    .publisher(for: GetArticlesByPublicationSlugsQuery(slugs: followedPublicationSlugs, limit: Constants.pageSize, offset: followedArticlesOffset))
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

        private func updateArticles(with articleFields: [ArticleFields]) {
            let newArticles = [Article](articleFields)

            switch followedArticles {
            case .loading:
                followedArticles = .results(newArticles)
            case .results(let articles):
                followedArticles = .results(articles + newArticles)
            case .reloading(let articles):
                followedArticles = .reloading(articles + newArticles)
            }

            if newArticles.count < Int(Constants.pageSize) {
                hasMorePages = false
            }
        }
    }
}
