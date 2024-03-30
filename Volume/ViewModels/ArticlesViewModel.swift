//
//  ArticlesViewModel.swift
//  Volume
//
//  Created by Vin Bui on 4/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension ArticlesView {

    @MainActor
    class ViewModel: ObservableObject {
        // MARK: - Properties

        @Published var deeplinkID: String?
        @Published var followedArticles: [Article]?
        @Published var hasMoreFollowedArticlePages = true
        @Published var hasMoreUnfollowedArticlePages = true
        @Published var isWeeklyDebriefOpen: Bool = false
        @Published var openArticleFromDeeplink: Bool = false
        @Published var searchState: SearchView.SearchState = .searching
        @Published var searchText: String = ""
        @Published var trendingArticles: [Article]?
        @Published var unfollowedArticles: [Article]?
        @Published var weeklyDebrief: WeeklyDebrief?

        private var networkState: NetworkState?
        private var publicationSlugs: [String]?
        private var queryBag = Set<AnyCancellable>()
        private var userData: UserData?

        // MARK: - Constants

        private struct Constants {
            static let followedArticlesLimit: Int = 20
            static let pageSize: Double = 10
            static let trendingArticleLimit: Double = 7
        }

        // MARK: - Property Helpers

        func setupEnvironment(networkState: NetworkState, userData: UserData) {
            if self.networkState == nil || self.userData == nil {
                self.networkState = networkState
                self.userData = userData
            }
        }

        private var followedPublicationSlugs: [String] {
            userData?.followedPublicationSlugs ?? []
        }

        private var unfollowedPublicationSlugs: [String] {
            publicationSlugs?.filter { slug -> Bool in
                !followedPublicationSlugs.contains(slug)
            } ?? []
        }

        var hasFollowedPublications: Bool {
            !followedPublicationSlugs.isEmpty
        }

        var disableScrolling: Bool {
            trendingArticles == .none
        }

        // MARK: - Requests

        func fetchContent() async {
            await fetchTrendingArticles()
            await fetchWeeklyDebrief()

            if followedArticles == nil {
                await fetchPublications()
                await fetchFirstPage()
            }
        }

        func refreshContent() async {
            Network.client.clearCache()
            queryBag.removeAll()

            trendingArticles = nil
            followedArticles = nil
            weeklyDebrief = nil
            unfollowedArticles = nil
            publicationSlugs = nil

            await fetchContent()
        }

        func fetchTrendingArticles() async {
            Network.client.queryPublisher(
                query: VolumeAPI.GetTrendingArticlesQuery(
                    limit: Constants.trendingArticleLimit
                )
            )
            .compactMap { $0.data?.articles.map(\.fragments.articleFields) }
            .sink { [weak self] completion in
                self?.networkState?.handleCompletion(screen: .reads, completion)
            } receiveValue: { [weak self] articleFieldsList in
                self?.trendingArticles = [Article](articleFieldsList)
            }
            .store(in: &queryBag)
        }

        func fetchWeeklyDebrief() async {
            func fetch() {
                guard let uuid = userData?.uuid else {
#if DEBUG
                    print("Error: received nil UUID from UserData")
#endif
                    return
                }

                Network.client.queryPublisher(query: VolumeAPI.GetWeeklyDebriefQuery(uuid: uuid))
                    .map(\.data?.user?.weeklyDebrief)
                    .sink { [weak self] completion in
                        self?.networkState?.handleCompletion(screen: .reads, completion)
                    } receiveValue: { [weak self] weeklyDebriefFields in
                        guard let weeklyDebriefFields else {
#if DEBUG
                            print("Error: GetWeeklyDebrief failed on ArticlesView: field \"weeklyDebrief\" is nil.")
#endif
                            self?.weeklyDebrief = nil
                            return
                        }

                        let weeklyDebrief = WeeklyDebrief(from: weeklyDebriefFields)
                        self?.userData?.weeklyDebrief = weeklyDebrief
                        self?.weeklyDebrief = weeklyDebrief
                        self?.isWeeklyDebriefOpen = !weeklyDebrief.isExpired
                    }
                    .store(in: &queryBag)
            }

            if let cachedWeeklyDebrief = userData?.weeklyDebrief {
                if cachedWeeklyDebrief.isExpired {
                    // Cached WD expired, query new one
                    fetch()
                } else {
                    // Cached WD still fresh, stop loading state
                    weeklyDebrief = cachedWeeklyDebrief
                }
            } else {
                // No existing WD, query new one
                fetch()
            }
        }

        func fetchPublications() async {
            Network.client.queryPublisher(query: VolumeAPI.GetAllPublicationsQuery())
                .compactMap { $0.data?.publications.map(\.slug) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .reads, completion)
                } receiveValue: { [weak self] slugs in
                    self?.publicationSlugs = slugs
                }
                .store(in: &queryBag)
        }

        func fetchFirstPage() async {
            Network.client.queryPublisher(
                query: VolumeAPI.GetArticlesByPublicationSlugsQuery(
                    slugs: followedPublicationSlugs,
                    limit: Constants.pageSize
                )
            )
            .compactMap { $0.data?.articles.map(\.fragments.articleFields) }
            .sink { [weak self] completion in
                self?.networkState?.handleCompletion(screen: .reads, completion)
            } receiveValue: { [weak self] articleFields in
                self?.updateArticles(followed: true, with: articleFields)
            }
            .store(in: &queryBag)
        }

        func fetchPage(followed: Bool) async {
            let slugs = followed ? followedPublicationSlugs : unfollowedPublicationSlugs
            Network.client
                .queryPublisher(
                    query: VolumeAPI.GetShuffledArticlesByPublicationSlugsQuery(
                        slugs: slugs,
                        limit: Constants.pageSize,
                        offset: GraphQLNullable<Double>(floatLiteral: offset(
                            for: followed ? followedArticles : unfollowedArticles)
                        )
                    )
                )
                .compactMap { $0.data?.articles.map(\.fragments.articleFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .reads, completion)
                } receiveValue: { [weak self] articleFields in
                    self?.updateArticles(followed: followed, with: articleFields)
                }
                .store(in: &queryBag)
        }

        // MARK: - Deeplink

        func handleURL(_ url: URL) {
            if url.isDeeplink, url.contentType == .article, let id = url.parameters["id"] {
                deeplinkID = id
                openArticleFromDeeplink = true
            }
        }

        // MARK: - Helpers

        private func offset(for articles: [Article]?) -> Double {
            Double(articles?.count ?? 0)
        }

        private func updateArticles(followed: Bool, with articleFields: [VolumeAPI.ArticleFields]) {
            let newArticles = [Article](articleFields)

            switch followed ? followedArticles : unfollowedArticles {
            case .none:
                if followed {
                    followedArticles = newArticles
                } else {
                    unfollowedArticles = newArticles
                }
            case .some(let articles):
                if followed {
                    followedArticles = articles + newArticles
                } else {
                    unfollowedArticles = articles + newArticles
                }
            }

            if newArticles.count < Int(Constants.pageSize) {
                if followed {
                    hasMoreFollowedArticlePages = false
                } else {
                    hasMoreUnfollowedArticlePages = false
                }
            }

            if followedArticles?.count ?? 0 > Constants.followedArticlesLimit {
                hasMoreFollowedArticlePages = false
            }
        }
    }

}
