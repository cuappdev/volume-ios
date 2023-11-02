//
//  TrendingViewModel.swift
//  Volume
//
//  Created by Vin Bui on 4/5/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
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
            Network.shared.clearCache()
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
            Network.shared.publisher(for: GetTrendingFlyersQuery(limit: 2))
                .map { $0.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] flyerFields in
                    self?.flyers = [Flyer](flyerFields)
                }
                .store(in: &queryBag)
        }

        func fetchMagazines() async {
            Network.shared.publisher(
                for: GetAllMagazinesQuery(
                    limit: Constants.magazinesLimit,
                    offset: 0
                )
            )
            .map { $0.magazines.map(\.fragments.magazineFields) }
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
            Network.shared.publisher(for: IncrementTimesClickedMutation(id: flyer.id))
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                    print("Marked flyer \(flyer.id) read")
                } receiveValue: { _ in
                }
                .store(in: &queryBag)
        }

        // MARK: - Private Requests

        private func fetchMainArticle() async {
            // MARK: Currently uncommented in case trending is not working on backend
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

            Network.shared.publisher(
                for: GetArticlesByPublicationSlugQuery(
                    slug: "guac",
                    limit: Constants.mainArticleLimit,
                    offset: Double.random(in: 0..<20)
                )
            )
            .map { $0.articles.map(\.fragments.articleFields) }
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
            Network.shared.publisher(
                for: GetTrendingArticlesQuery(
                    limit: Constants.subArticlesLimit
                )
            )
            .map { $0.articles.map(\.fragments.articleFields) }
            .sink { [weak self] completion in
                self?.networkState?.handleCompletion(screen: .trending, completion)
            } receiveValue: { [weak self] articleFields in
                self?.subArticles = [Article](articleFields)
            }
            .store(in: &queryBag)
        }

    }

}
