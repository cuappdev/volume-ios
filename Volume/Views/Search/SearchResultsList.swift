//
//  SearchQueryResults.swift
//  Volume
//
//  Created by Vian Nguyen on 11/25/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

struct SearchResultsList: View {

    let searchText: String

    @EnvironmentObject private var networkState: NetworkState
    @State private var sectionQueries: SectionQueries = (nil, nil, nil)
    @State private var sectionStates: SectionStates = (.loading, .loading, .loading)
    @State private var selectedTab: FilterContentType = .articles

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

    private var hasFlyerSearchResults: Bool {
        switch sectionStates.flyers {
        case .loading, .reloading:
            return true
        case .results(let searchFlyers):
            return searchFlyers.count > 0
        }
    }

    // MARK: - Network Requests

    private func fetchContent(_ done: @escaping () -> Void = { }) {
        guard sectionStates.articles.isLoading else { return }
        guard sectionStates.magazines.isLoading else { return }
        guard sectionStates.flyers.isLoading else { return }

        fetchSearchedArticles(done)
        fetchSearchedMagazines(done)
        fetchSearchedFlyers(done)
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

    private func fetchSearchedFlyers(_ done: @escaping () -> Void = { }) {
        sectionQueries.flyers = Network.shared.publisher(for: SearchFlyersQuery(query: searchText))
            .compactMap {
                $0.flyer.map(\.fragments.flyerFields)
            }
            .sink { completion in
                networkState.handleCompletion(screen: .search, completion)
            } receiveValue: { flyerFields in
                let searchedFlyers = [Flyer](flyerFields)
                withAnimation(.linear(duration: Constants.animationDuration)) {
                    sectionStates.flyers = .results(searchedFlyers)
                }
                done()
            }
    }

    // MARK: - UI

    var body: some View {
        VStack {
            ContentFilterBarView(selectedTab: $selectedTab, showFlyerTab: true)

            ScrollView {
                switch selectedTab {
                case .articles:
                    articleSection
                case .magazines:
                    magazineSection
                case .flyers:
                    flyerSection
                }
            }
            .refreshable {
                if case let .results(articles) = sectionStates.articles,
                   case let .results(magazines) = sectionStates.magazines,
                   case let .results(flyers) = sectionStates.flyers {

                    sectionStates.articles = .reloading(articles)
                    sectionStates.magazines = .reloading(magazines)
                    sectionStates.flyers = .reloading(flyers)
                }

                sectionStates.articles = .loading
                sectionStates.magazines = .loading
                sectionStates.flyers = .loading

                fetchContent()
            }
            .onAppear {
                fetchContent()
            }
            .padding(.horizontal)
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
                ForEach(0..<Constants.articleSkeletonSize, id: \.self) { _ in
                    ArticleRow.Skeleton()
                }
            case .reloading(let searchedArticles), .results(let searchedArticles):
                LazyVStack {
                    ForEach(searchedArticles) { article in
                        NavigationLink(
                            destination: BrowserView(
                                initType: .readyForDisplay(article),
                                navigationSource: .searchArticles
                            )
                        ) {
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
                    .padding(.horizontal, 16)
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

    @ViewBuilder
    private var flyerSection: some View {
        if hasFlyerSearchResults {
            flyerList
        } else {
            VolumeMessage(message: .noSearchResults, largeFont: true, fullWidth: true)
                .padding(.vertical, Constants.emptyResultsMessagePadding)
        }
    }

    private var flyerList: some View {
        VStack(spacing: Constants.rowVerticalPadding) {
            switch sectionStates.flyers {
            case .loading:
                ForEach(0..<4) { _ in
                    FlyerCellPast.Skeleton()
                        .padding(.bottom, 16)
                }
            case .reloading(let searchedFlyers), .results(let searchedFlyers):
                ForEach(searchedFlyers) { flyer in
                    if let urlString = flyer.imageUrl?.absoluteString {
                        FlyerCellPast(
                            flyer: flyer,
                            navigationSource: .searchFlyers,
                            urlImageModel: URLImageModel(urlString: urlString),
                            viewModel: FlyersView.ViewModel()
                        )
                    }
                }
            }
        }
    }

}

extension SearchResultsList {

    // swiftlint:disable:next large_tuple
    typealias SectionStates = (
        articles: MainView.TabState<[Article]>,
        magazines: MainView.TabState<[Magazine]>,
        flyers: MainView.TabState<[Flyer]>
    )

    // swiftlint:disable:next large_tuple
    typealias SectionQueries = (
        articles: AnyCancellable?,
        magazines: AnyCancellable?,
        flyers: AnyCancellable?
    )

}
