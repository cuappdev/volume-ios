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
    @State private var cancellableQuery: AnyCancellable?
    @State private var openedUrl = false
    @State private var state: MainView.TabState<Results> = .loading
    @State private var onOpenArticleUrl: Article? = nil
    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var userData: UserData

    private func fetch(_ done: @escaping () -> Void = { }) {
        guard state.isLoading else { return }

        cancellableQuery = Network.shared.apollo.publisher(for: GetAllPublicationIDsQuery())
            .map { $0.publications.map(\.id) }
            .flatMap { publicationIDs -> ResultsPublisher in
                let trendingQuery = Network.shared.apollo.publisher(for: GetTrendingArticlesQuery(limit: 7))
                    .map { $0.articles.map(\.fragments.articleFields) }

                let followedQuery = Network.shared.apollo.publisher(for: GetArticlesByPublicationIDsQuery(ids: userData.followedPublicationIDs))
                    .map { $0.articles.map(\.fragments.articleFields) }
                    .collect()

                let morePublicationIDs = publicationIDs.filter { !userData.followedPublicationIDs.contains($0) }

                let otherQuery = Network.shared.apollo.publisher(for: GetArticlesByPublicationIDsQuery(ids: morePublicationIDs))
                    .map { $0.articles.map(\.fragments.articleFields) }
                
                return Publishers.Zip3(trendingQuery, followedQuery, otherQuery)
            }
            .sink { completion in
                networkState.handleCompletion(screen: .homeList, completion)
            } receiveValue: { (trendingArticles, followed, other) in
                // Exclude trending articles from following articles
                // Take up to 20 followed articles, sorted in descending chronological order
                let followedArticles = Array(followed.joined().filter { article in
                    !trendingArticles.contains(where: { $0.id == article.id })
                }).sorted(by: { $0.date > $1.date }).prefix(20)
                // Exclude followed and trending articles from other articles
                let otherArticles = Array(other.filter { article in
                    !(followedArticles.contains(where: { $0.id == article.id })
                        || trendingArticles.contains(where: { $0.id == article.id }))
                }).sorted(by: { $0.date > $1.date }).prefix(45)
                
                done()
                withAnimation(.linear(duration: 0.1)) {
                    state = .results((
                        trendingArticles: [Article](trendingArticles),
                        followedArticles: [Article](followedArticles),
                        otherArticles: [Article](otherArticles)
                    ))
                }
            }
    }

    private func fetchArticleBy(id: String) {
        cancellableQuery = Network.shared.apollo.publisher(for: GetArticleByIdQuery(id: id))
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { (article) in
                let fields = article.article?.fragments.articleFields
                if let fields = fields {
                    onOpenArticleUrl = Article(from: fields)
                    openedUrl = true
                }
            }
    }

    var body: some View {
        RefreshableScrollView(onRefresh: { done in
            switch state {
            case .loading, .reloading:
                return
            case .results(let results):
                state = .reloading(results)
                fetch(done)
            }
        }) {
            VStack(spacing: 20) {
                Header("The Big Read")
                    .padding([.top, .leading, .trailing])
                ScrollView(.horizontal, showsIndicators: false) {
                    switch state {
                    case .loading:
                        HStack(spacing: 24) {
                            ForEach(0..<2) { _ in
                                BigReadArticleRow.Skeleton()
                            }
                        }
                    case .reloading(let results), .results(let results):
                        HStack(spacing: 24) {
                            ForEach(results.trendingArticles) { article in
                                BigReadArticleRow(article: article)
                            }
                        }
                    }
                }
                .padding([.leading, .trailing])

                Header("Following")
                    .padding([.leading, .trailing])
                    .padding(.top, 36)
                switch state {
                case .loading:
                    ForEach(0..<5) { _ in
                        ArticleRow.Skeleton()
                            .padding([.leading, .trailing])
                    }
                case .reloading(let results), .results(let results):
                    ForEach(results.followedArticles) { article in
                        ArticleRow(article: article, navigationSource: .followingArticles)
                            .padding([.leading, .trailing])
                    }
                }

                Spacer()

                VolumeMessage(message: .upToDate)
                    .padding(.top, 25)
                    .padding(.bottom, -5)

                Spacer()

                Header("Other Articles").padding()
                switch state {
                case .loading:
                    // will be off the page, so pointless to show anything
                    Spacer().frame(height: 0)
                case .reloading(let results), .results(let results):
                    ForEach(results.otherArticles) { article in
                        ArticleRow(article: article, navigationSource: .otherArticles)
                            .padding([.bottom, .leading, .trailing])
                    }
                }

                // Invisible navigation link only opens if application is opened
                // through deeplink with valid article
                if let url = onOpenArticleUrl {
                    NavigationLink("", destination: BrowserView(article: url, navigationSource: .morePublications), isActive: $openedUrl)
                }
            }
        }
        .disabled(state.shouldDisableScroll)
        .padding(.top)
        .background(Color.volume.backgroundGray)
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                Image("volume-logo")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetch()
        }
        .onOpenURL { url in
            let parameters = url.parameters
            if let id = parameters["id"] {
                fetchArticleBy(id: id)
            }
        }
    }

}

extension HomeList {
    typealias Results = (
        trendingArticles: [Article],
        followedArticles: [Article],
        otherArticles: [Article]
    )
    typealias ResultsPublisher =
        Publishers.Zip3<
            Publishers.Map<GraphQLPublisher<GetTrendingArticlesQuery.Data>,[ArticleFields]>,
            Publishers.Collect<Publishers.Map<GraphQLPublisher<GetArticlesByPublicationIDsQuery.Data>, [ArticleFields]>>,
            Publishers.Map<GraphQLPublisher<GetArticlesByPublicationIDsQuery.Data>, [ArticleFields]>
        >
}

struct HomeList_Previews: PreviewProvider {
    static var previews: some View {
        HomeList()
    }
}
