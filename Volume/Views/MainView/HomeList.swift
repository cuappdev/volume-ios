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
    @State private var state: HomeListState = .loading
    @EnvironmentObject private var userData: UserData

    private var isLoading: Bool {
        switch state {
        case .loading:
            return true
        default:
            return false
        }
    }

    private func fetch() {
        guard isLoading else { return }

        cancellableQuery = Network.shared.apollo.fetch(query: GetAllPublicationIDsQuery())
            .map { $0.publications.map(\.id) }
            .flatMap { publicationIDs -> ResultsPublisher in
                let trendingQuery = Network.shared.apollo.fetch(query: GetTrendingArticlesQuery(limit: 7))
                    .map { $0.articles.map(\.fragments.articleFields) }

                let followedQuery = Network.shared.apollo.fetch(query: GetArticlesByPublicationIDsQuery(ids: userData.followedPublicationIDs))
                    .map { $0.articles.map(\.fragments.articleFields) }
                    .collect()

                let morePublicationIDs = publicationIDs.filter { !userData.followedPublicationIDs.contains($0) }

                let otherQuery = Network.shared.apollo.fetch(query: GetArticlesByPublicationIDsQuery(ids: morePublicationIDs))
                    .map { $0.articles.map(\.fragments.articleFields) }
                
                return Publishers.Zip3(trendingQuery, followedQuery, otherQuery)
            }
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
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

                withAnimation(.linear(duration: 0.1)) {
                    state = .results((
                        trendingArticles: [Article](trendingArticles),
                        followedArticles: [Article](followedArticles),
                        otherArticles: [Article](otherArticles)
                    ))
                }
            }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    Header("The Big Read").padding(.bottom, -12)
                    ScrollView(.horizontal, showsIndicators: false) {
                        switch state {
                        case .loading:
                            HStack(spacing: 24) {
                                ForEach(0..<2) { _ in
                                    BigReadArticleRow.Skeleton()
                                }
                            }
                        case .results(let results):
                            LazyHStack(spacing: 24) {
                                ForEach(results.trendingArticles) { article in
                                    BigReadArticleRow(article: article)
                                }
                            }
                        }
                    }
                    .padding([.bottom, .leading, .trailing])
                    
                    Header("Following").padding(.bottom, -12)
                    switch state {
                    case .loading:
                        ForEach(0..<5) { _ in
                            ArticleRow.Skeleton()
                                .padding([.bottom, .leading, .trailing])
                        }
                    case .results(let results):
                        ForEach(results.followedArticles) { article in
                            ArticleRow(article: article)
                                .padding([.bottom, .leading, .trailing])
                        }
                    }
                    
                    VolumeMessage(message: .upToDate)
                        .padding([.top, .bottom], 25)
                    
                    Header("Other Articles").padding(.bottom, -12)
                    switch state {
                    case .loading:
                        // will be off the page, so pointless to show anything
                        Spacer().frame(height: 0)
                    case .results(let results):
                        ForEach(results.otherArticles) { article in
                            ArticleRow(article: article)
                                .padding([.bottom, .leading, .trailing])
                        }
                    }
                }
            }
            .disabled(isLoading)
            .padding(.top)
            .background(Color.volume.backgroundGray)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Image("volume-logo")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: fetch)
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
            Publishers.Map<GraphQLPublisher<GetTrendingArticlesQuery>,[ArticleFields]>,
            Publishers.Collect<Publishers.Map<GraphQLPublisher<GetArticlesByPublicationIDsQuery>, [ArticleFields]>>,
            Publishers.Map<GraphQLPublisher<GetArticlesByPublicationIDsQuery>, [ArticleFields]>
        >
    private enum HomeListState {
        case loading
        case results(Results)
    }
}

struct HomeList_Previews: PreviewProvider {
    static var previews: some View {
        HomeList()
    }
}
