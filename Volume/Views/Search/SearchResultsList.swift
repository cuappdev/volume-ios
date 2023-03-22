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
    @State private var selectedTab: Publication.ContentType = .articles
    let searchText: String

    private struct Constants {
        static let animationDuration: CGFloat = 0.1
        static let articleSkeletonSize: Int = 10
        static let emptyResultsMessagePadding: CGFloat = 135
        static let gridColumns: Array = Array(repeating: GridItem(.flexible()), count: 2)
        static let magazineSkeletonSize: Int = 4
        static let magazineVerticalSpacing: CGFloat = 30
        static let rowVerticalPadding: CGFloat = 10
    }

    private var hasArticleSearchResults: Bool {
        switch sectionStates.articles {
        case .loading, .reloading:
            return true
        case .results(let searchedArticles):
            return searchedArticles.count > 0
        }
    }

    private var hasMagazineSearchResults: Bool {
        switch sectionStates.magazines {
        case .loading, .reloading:
            return true
        case .results(let searchedMagazines):
            return searchedMagazines.count > 0
        }
    }

    // MARK: - Network Requests

    private func fetchContent(_ done: @escaping () -> Void = { }) {
        guard sectionStates.articles.isLoading else { return }

        fetchSearchedArticles(done)
        fetchSearchedMagazines(done)
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
        sectionQueries.magazines = Network.shared.publisher(for: SearchMagazinesQuery(query: searchText))
            .compactMap {
                $0.magazine.map(\.fragments.magazineFields)
            }
            .sink { completion in
                networkState.handleCompletion(screen: .search, completion)
            } receiveValue: { magazineFields in
                Task {
                    let searchedMagazines = await [Magazine](magazineFields)
                    withAnimation(.linear(duration: Constants.animationDuration)) {
                        sectionStates.magazines = .results(searchedMagazines)
                    }
                    done()
                }
            }
    }

    // MARK: - UI

    var body: some View {
        SearchTabBar(selectedTab: $selectedTab)

        Spacer()
            .frame(height: Constants.rowVerticalPadding)

        RefreshableScrollView(onRefresh: { done in
            if case let .results(articles) = sectionStates.articles,
               case let .results(magazines) = sectionStates.magazines {

                sectionStates.articles = .reloading(articles)
                sectionStates.magazines = .reloading(magazines)
            }

            sectionStates.articles = .loading
            sectionStates.magazines = .loading

            fetchContent(done)
            }) {
                switch selectedTab {
                case .articles:
                    articleSection
                case .magazines:
                    magazineSection
                }
            }
            .disabled(sectionStates.articles.isLoading)
            .disabled(sectionStates.magazines.isLoading)
            .onAppear {
                fetchContent()
            }
        }

    }

    @ViewBuilder
    private var articleSection: some View {
        if hasArticleSearchResults {
            articleList
                .padding(.horizontal)
        } else {
            VolumeMessage(message: .noSearchResults, largeFont: true, fullWidth: true)
                .padding(.vertical, Constants.emptyResultsMessagePadding)
        }
    }

    private var articleList: some View {
        VStack(spacing: Constants.rowVerticalPadding) {
            switch sectionStates.articles {
            case .loading:
                ForEach(0..<Constants.articleSkeletonSize, id: \.self) { _ in
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

    @ViewBuilder
    private var magazineSection: some View {
        if hasMagazineSearchResults {
            magazineList
        } else {
            VolumeMessage(message: .noSearchResults, largeFont: true, fullWidth: true)
                .padding(.vertical, Constants.emptyResultsMessagePadding)
        }
    }

    private var magazineList: some View {
        VStack(spacing: Constants.rowVerticalPadding) {
            switch sectionStates.magazines {
            case .loading:
                ForEach(0..<Constants.magazineSkeletonSize / 2, id: \.self) { _ in
                    HStack {
                        MagazineCell.Skeleton()

                        Spacer()

                        MagazineCell.Skeleton()
                    }
                }
                .padding(.top)
            case .reloading(let searchedMagazines), .results(let searchedMagazines):
                LazyVGrid(columns: Constants.gridColumns, spacing: Constants.magazineVerticalSpacing) {
                    ForEach(searchedMagazines) { magazine in
                        NavigationLink {
                            MagazineReaderView(initType: .readyForDisplay(magazine), navigationSource: .moreMagazines)
                        } label: {
                            MagazineCell(magazine: magazine)
                        }
                    }
                }
                .padding(.bottom)
                .padding(.top)
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

