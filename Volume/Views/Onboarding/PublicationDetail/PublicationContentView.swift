//
//  PublicationContentView.swift
//  Volume
//
//  Created by Hanzheng Li on 11/18/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationContentView: View {

    @EnvironmentObject private var networkState: NetworkState
    @Namespace private var namespace
    @StateObject var viewModel: ViewModel

    var body: some View {
        Group {
            switch viewModel.magazines {
            case .none:
                loadingView
            case .some(_):
                contentView
            }
        }
        .onAppear {
            viewModel.setupEnvironmentVariables(networkState: networkState)
            viewModel.fetchContent()
        }
    }

    private var loadingView: some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: Constants.loadingIndicatorTopPadding)

            ProgressView()
        }
    }

    private var contentView: some View {
        LazyVStack {
            tabBar

            Group {
                switch viewModel.selectedTab {
                case .articles:
                    articleTab
                case .magazines:
                    magazineTab
                }
            }
        }
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            if viewModel.showArticleTab {
                tabBarItem(title: Constants.articleTabTitle, tab: .articles)
                    .frame(width: Constants.articleTabWidth)
            }

            if viewModel.showMagazineTab {
                tabBarItem(title: Constants.magazineTabTitle, tab: .magazines)
                    .frame(width: Constants.magazineTabWidth)
            }
            Spacer()
        }
        .padding(.horizontal)
    }

    private func tabBarItem(title: String, tab: PublicationContentType) -> some View {
        VStack(alignment: .center, spacing: Constants.tabBarItemSpacing) {
            Text(title)
                .font(Constants.tabTitleFont)
                .foregroundColor(viewModel.selectedTab == tab ? Color.volume.orange : .black)
                .padding(.top)

            if viewModel.selectedTab == tab {
                Color.volume.orange
                    .frame(height: Constants.tabUnderlineHeight)
                    .matchedGeometryEffect(
                        id: "underline",
                        in: namespace,
                        properties: .frame
                    )
            } else {
                Color.volume.veryLightGray
                    .frame(height: Constants.tabUnderlineHeight)
            }
        }
        .animation(.spring(), value: viewModel.selectedTab)
        .onTapGesture {
            viewModel.selectedTab = tab
        }
    }

    private var articleTab: some View {
        Group {
            switch viewModel.articles {
            case .none:
                ForEach(0..<5) { _ in
                    articleRowSkeleton
                }
            case .some(let articles):
                ForEach(articles, id: \.id) { article in
                    NavigationLink {
                        BrowserView(
                            initType: .readyForDisplay(article),
                            navigationSource: .publicationDetail
                        )
                    } label: {
                        ArticleRow(
                            article: article,
                            navigationSource: .publicationDetail,
                            showsPublicationName: false
                        )
                        .padding([.horizontal, .top])
                        .onAppear {
                            viewModel.fetchPageIfLast(article: article)
                        }
                    }
                }

                if viewModel.hasMorePages {
                    articleRowSkeleton
                }
            }
        }
    }

    private var magazineTab: some View {
        Group {
            switch viewModel.magazines {
            case .none:
                ForEach(0..<2) { _ in
                    HStack {
                        MagazineCell.Skeleton()

                        Spacer()

                        MagazineCell.Skeleton()
                    }
                    .padding()
                }
            case .some(let magazines):
                ForEach(0..<magazines.count / 2, id: \.self) { row in
                    HStack {
                        magazineCellRow(
                            first: magazines[row * 2],
                            second: (row * 2 + 1) < magazines.count ? magazines[row * 2 + 1] : nil
                        )
                    }
                }
            }
        }
    }

    // MARK: Helpers

    private var articleRowSkeleton: some View {
        ArticleRow.Skeleton(showsPublicationName: false)
            .padding([.horizontal, .bottom])
    }

    private func magazineCellRow(first: Magazine, second: Magazine?) -> some View {
        HStack {
            magazineCellLink(magazine: first)

            Spacer()

            if let second {
                magazineCellLink(magazine: second)
            } else {
                Spacer()
            }
        }
        .padding()
    }

    private func magazineCellLink(magazine: Magazine) -> some View {
        NavigationLink {
            MagazineReaderView(magazine: magazine)
        } label: {
            MagazineCell(magazine: magazine)
        }
    }
}

extension PublicationContentView {

    private struct Constants {
        static let articleTabTitle = "Articles"
        static let magazineTabTitle = "Magazines"
        static let tabUnderlineHeight: CGFloat = 2
        static let tabTitleFont: Font = .newYorkMedium(size: 18)
        static let articleTabWidth: CGFloat = 80
        static let magazineTabWidth: CGFloat = 106
        static let tabBarItemSpacing: CGFloat = 8
        static let loadingIndicatorTopPadding: CGFloat = 180
    }
}
