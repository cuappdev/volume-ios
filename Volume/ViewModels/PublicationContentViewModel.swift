//
//  PublicationContentViewModel.swift
//  Volume
//
//  Created by Hanzheng Li on 11/18/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension PublicationContentView {

    @MainActor
    class ViewModel: ObservableObject {

        let publication: Publication
        let navigationSource: NavigationSource
        private var networkState: NetworkState?

        @Published var articles: [Article]?
        @Published var magazines: [Magazine]?
        @Published var hasMorePages: Bool = true
        @Published var selectedTab: FilterContentType = .articles
        @Published private var queryBag = Set<AnyCancellable>()

        var showArticleTab: Bool {
            publication.numArticles > 0
        }

        var showMagazineTab: Bool {
            guard let magazines else {
                return false
            }
            return magazines.count > 0
        }

        nonisolated init(publication: Publication, navigationSource: NavigationSource) {
            self.publication = publication
            self.navigationSource = navigationSource
        }

        func setupEnvironmentVariables(networkState: NetworkState) {
            self.networkState = networkState
        }

        func fetchContent() async {
            await fetchMagazines()
            if showArticleTab {
                await fetchPage()
            }
        }

        func fetchMagazines() async {
            Network.client.queryPublisher(
                query: VolumeAPI.GetMagazinesByPublicationSlugQuery(slug: publication.slug)
            )
            .compactMap { $0.data?.magazines.map(\.fragments.magazineFields) }
            .sink { [weak self] completion in
                self?.networkState?.handleCompletion(
                    screen: .publicationDetail,
                    completion
                )
            } receiveValue: { [weak self] magazineFields in
                self?.selectedTab = self?.showArticleTab ?? false ? .articles : .magazines
                Task {
                    self?.magazines = await [Magazine](magazineFields)
                }
            }
            .store(in: &queryBag)
        }

        func fetchPageIfLast(article: Article) {
            if let articles, articles.firstIndex(of: article) == articles.index(articles.endIndex, offsetBy: -1) {
                Task {
                    await fetchPage()
                }
            }
        }

        private func fetchPage() async {
            Network.client.queryPublisher(
                query: VolumeAPI.GetArticlesByPublicationSlugQuery(
                    slug: publication.slug,
                    limit: Constants.pageSize,
                    offset: GraphQLNullable<Double>(floatLiteral: Double(articles?.count ?? 0))
                )
            )
            .compactMap { $0.data?.articles.map(\.fragments.articleFields) }
            .sink { [weak self] completion in
                self?.networkState?.handleCompletion(screen: .reads, completion)
            } receiveValue: { [weak self] articleFields in
                let newArticles = [Article](articleFields.sorted { $0.date > $1.date })

                if newArticles.count < Int(Constants.pageSize) {
                    self?.hasMorePages = false
                }

                withAnimation(.linear(duration: Constants.animationDuration)) {
                    if let self {
                        self.articles = (self.articles ?? []) + newArticles
                    }
                }
            }
            .store(in: &queryBag)
        }

        // MARK: Helpers

        private struct Constants {
            static let animationDuration: CGFloat = 0.1
            static let pageSize: Double = 10
            static let articleRowHeight: CGFloat = 80
        }

    }

}
