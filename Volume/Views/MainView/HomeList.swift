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
    @State private var cancellableQuery: Cancellable?
    @State private var state: HomeListState = .loading
    
    private func fetch() {
        guard let date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
            return
        }
        let query = GetHomeArticlesQuery(since: date.dateString)
        cancellableQuery = Network.shared.apollo.fetch(query: query)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { value in
                withAnimation(.linear(duration: 0.1)) {
                    state = .results((
                        trendingArticles: [Article](value.trending),
                        followingArticles: [Article](value.following),
                        otherArticles: [Article](value.other)
                    ))
                }
            })
    }
    
    private var isLoading: Bool {
        switch state {
        case .loading:
            return true
        default:
            return false
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
                        ForEach(results.followingArticles) { article in
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
        followingArticles: [Article],
        otherArticles: [Article]
    )
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
