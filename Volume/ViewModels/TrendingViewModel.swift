//
//  TrendingViewModel.swift
//  Volume
//
//  Created by Vin Bui on 4/5/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import OSLog
import SwiftUI

extension TrendingView {

    @MainActor
    class ViewModel: ObservableObject {
        // MARK: - Properties

        @Published var flyers: [Flyer]?
        @Published var mainArticle: Article?
        @Published var magazines: [Magazine]?
        @Published var subArticles: [Article]?

        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()
        private var userData: UserData?

        // MARK: - Property Helpers

        func setupEnvironment(networkState: NetworkState, userData: UserData) {
            if self.networkState == nil || self.userData == nil {
                self.networkState = networkState
                self.userData = userData
            }
        }

        // MARK: - Logic Constants

        private struct Constants {
            static let flyersLimit: Double = 2
            static let mainArticleLimit: Double = 10
            static let magazinesLimit: Double = 4
            static let subArticlesLimit: Double = 3
        }

        // MARK: - Public Requests

        func fetchContent() async {
            mainArticle == nil ? await fetchMainArticle() : nil
            subArticles == nil ? await fetchSubArticles() : nil
        }

        func refreshContent() async {
            Network.client.clearCache()
            queryBag.removeAll()

            flyers = nil
            mainArticle = nil
            magazines = nil
            subArticles = nil

            Task {
                await fetchContent()
            }
        }

        func fetchFlyers() async {
            Network.client.queryPublisher(query: VolumeAPI.GetTrendingFlyersQuery(limit: 2))
                .compactMap { $0.data?.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] flyerFields in
                    self?.flyers = [Flyer](flyerFields)
                }
                .store(in: &queryBag)
        }

        func fetchMagazines() async {
            Network.client.queryPublisher(
                query: VolumeAPI.GetAllMagazinesQuery(
                    limit: Constants.magazinesLimit,
                    offset: 0
                )
            )
            .compactMap { $0.data?.magazines.map(\.fragments.magazineFields) }
            .sink { [weak self] completion in
                self?.networkState?.handleCompletion(screen: .trending, completion)
            } receiveValue: { [weak self] magazineFields in
                Task {
                    self?.magazines = await [Magazine](magazineFields)
                }
            }
            .store(in: &queryBag)
        }

        func readFlyer(_ flyer: Flyer) async {
            Network.client.mutationPublisher(mutation: VolumeAPI.IncrementTimesClickedMutation(id: flyer.id))
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { _ in
#if DEBUG
                    Logger.services.log("Marked flyer \(flyer.id) read")
#endif
                }
                .store(in: &queryBag)
        }

        // MARK: - Private Requests

        private func fetchMainArticle() async {
            // TODO: Currently uncommented in case trending is not working on backend
            //            Network.shared.publisher(for: GetTrendingArticlesQuery(limit: Constants.mainArticleLimit))
            //                .map { $0.articles.map(\.fragments.articleFields) }
            //                .sink { [weak self] completion in
            //                    self?.networkState?.handleCompletion(screen: .trending, completion)
            //                } receiveValue: { [weak self] articleFields in
            //                    let articles = [Article] (articleFields)
            //                    if let article = articles.randomElement() {
            //                        self?.mainArticle = article
            //                    }
            //                }
            //                .store(in: &queryBag)

            Network.client.queryPublisher(
                query: VolumeAPI.GetArticlesByPublicationSlugQuery(
                    slug: "guac",
                    limit: Constants.mainArticleLimit,
                    offset: GraphQLNullable<Double>(floatLiteral: Double.random(in: 0..<20))
                )
            )
            .compactMap { $0.data?.articles.map(\.fragments.articleFields) }
            .sink { [weak self] completion in
                self?.networkState?.handleCompletion(screen: .trending, completion)
            } receiveValue: { [weak self] articleFields in
                let articles = [Article](articleFields)
                if let article = articles.first {
                    self?.mainArticle = article
                }
            }
            .store(in: &queryBag)
        }

        private func fetchSubArticles() async {
            Network.client.queryPublisher(
                query: VolumeAPI.GetTrendingArticlesQuery(
                    limit: Constants.subArticlesLimit
                )
            )
            .compactMap { $0.data?.articles.map(\.fragments.articleFields) }
            .sink { [weak self] completion in
                self?.networkState?.handleCompletion(screen: .trending, completion)
            } receiveValue: { [weak self] articleFields in
                self?.subArticles = [Article](articleFields)
            }
            .store(in: &queryBag)
        }

    }

}
