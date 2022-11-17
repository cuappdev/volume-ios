//
//  PublicationDetailViewModel.swift
//  Volume
//
//  Created by Hanzheng Li on 11/16/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension PublicationDetail {
    @MainActor class ViewModel: ObservableObject {

        private struct Constants {
            static let animationDuration: CGFloat = 0.1
            static let pageSize: Double = 10
        }

        let publication: Publication
        let navigationSource: NavigationSource
        var networkState: NetworkState?

        @Published var articles: [Article]? = nil
        @Published var hasMorePages: Bool = true
        @Published var queryBag = Set<AnyCancellable>()

        init(publication: Publication, navigationSource: NavigationSource) {
            self.publication = publication
            self.navigationSource = navigationSource
        }

        func setup(networkState: NetworkState) {
            self.networkState = networkState
        }

        var disableScrolling: Bool {
            articles == nil
        }

        func fetchContent() {
            // TODO: implement pagination, default limit is 25
            fetchPage()
        }

        func fetchPageIfLast(article: Article) {
            if let articles, articles.firstIndex(of: article) == articles.index(articles.endIndex, offsetBy: -1) {
                fetchPage()
            }
        }

        private func fetchPage() {
            Network.shared.publisher(
                for: GetArticlesByPublicationSlugQuery(
                    slug: publication.slug,
                    limit: Constants.pageSize,
                    offset: Double(articles?.count ?? 0)
                )
            )
                .map { $0.articles.map(\.fragments.articleFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .publications, completion)
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
    }
}
