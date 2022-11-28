//
//  SearchQueryResults.swift
//  Volume
//
//  Created by Vian Nguyen on 11/25/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

enum SearchTab {
    case articles, magazines
}

struct SearchResultsList: View {
    @EnvironmentObject private var networkState: NetworkState
    @State private var sectionQueries: SectionQueries = (nil, nil)
    @State private var sectionStates: SectionStates = (.loading, .loading)
    @State private var selectedTab: SearchTab = .articles
    let searchText: String
    
    private struct Constants {
        static let animationDuration: CGFloat = 0.1
        static let emptyResultsMessagePadding: CGFloat = 135
        static let rowVerticalPadding: CGFloat = 10
        static let skeletonSize: Int = 10
    }
    
    private var hasArticleSearchResults: Bool {
        switch sectionStates.articles {
        case .loading, .reloading:
            return true
        case .results(let searchedArticles):
            return searchedArticles.count > 0
        }
    }
    
    private func fetchContent(_ done: @escaping () -> Void = { }) {
        guard sectionStates.articles.isLoading else { return }
        
        fetchSearchedArticles(done)
        fetchSearchedMagazines()
    }
    
    private func fetchSearchedArticles(_ done: @escaping () -> Void = { }) {
        sectionQueries.articles = Network.shared.publisher(for: SearchArticlesQuery(query: searchText))
            .compactMap {
                $0.article.map(\.fragments.articleFields)
            }
            .sink { completion in
                networkState.handleCompletion(screen: .search, completion)
            } receiveValue: { articleFields in
                let searchedArticles = [Article](articleFields)
                withAnimation(.linear(duration: Constants.animationDuration)) {
                    sectionStates.articles = .results(searchedArticles)
                }
                done()
            }
    }
    
    private func fetchSearchedMagazines(_ done: @escaping () -> Void = { }) {
        //TODO: Add magazine search once implemented by backend
        
    }
    
    var body: some View {
        SearchTabBar(selectedTab: $selectedTab)
        
        Spacer()
            .frame(height: Constants.rowVerticalPadding)

        RefreshableScrollView(onRefresh: { done in
            if case let .results(articles) = sectionStates.articles {
                sectionStates.articles = .reloading(articles)
            }
            
            sectionStates.articles = .loading
            
            fetchContent(done)
            }) {
                switch selectedTab {
                case .articles:
                    articleSection
                case .magazines:
                    EmptyView()
                }
            }
            .disabled(sectionStates.articles.isLoading)
            .onAppear {
                fetchContent()
            }
    }
    
    @ViewBuilder
    private var articleSection: some View {
        if hasArticleSearchResults {
            articleList
        } else {
            VolumeMessage(message: .noSearchResults, largeFont: true, fullWidth: true)
                .padding(.vertical, Constants.emptyResultsMessagePadding)
        }
    }
    
    private var articleList: some View {
        VStack(spacing: Constants.rowVerticalPadding) {
            switch sectionStates.articles {
            case .loading:
                ForEach(0..<Constants.skeletonSize, id: \.self) { _ in
                     ArticleRow.Skeleton()
                }
            case .reloading(let searchedArticles), .results(let searchedArticles):
                LazyVStack {
                    ForEach(searchedArticles) { article in
                        NavigationLink(destination: BrowserView(initType: .readyForDisplay(article), navigationSource: .searchArticles)) {
                            ArticleRow(article: article, navigationSource: .searchArticles)
                                .padding(.vertical)
                        }
                    }
                }
            }
        }
    }
    
}

extension SearchResultsList {
    typealias SectionStates = (
        articles: MainView.TabState<[Article]>,
        magazines: MainView.TabState<[Magazine]>
    )
    
    typealias SectionQueries = (
        articles: AnyCancellable?,
        magazines: AnyCancellable?
    )
}

