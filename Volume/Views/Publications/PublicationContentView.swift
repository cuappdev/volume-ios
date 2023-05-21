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
                    articleContent
                case .magazines:
                    magazineContent
                case .flyers:
                    SkeletonView()
                }
            }
        }
    }

    private var tabBar: some View {
        ContentFilterBarView(selectedTab: $viewModel.selectedTab, showArticleTab: viewModel.showArticleTab, showMagazineTab: viewModel.showMagazineTab, showFlyerTab: false)
    }

    private var articleContent: some View {
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

    private var magazineContent: some View {
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
                ForEach(0..<(magazines.count + 1) / 2, id: \.self) { row in
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
            MagazineReaderView(initType: .readyForDisplay(magazine), navigationSource: viewModel.navigationSource)
        } label: {
            MagazineCell(magazine: magazine)
        }
    }
}

extension PublicationContentView {

    private struct Constants {
        static let articleTabTitle = "Articles"
        static let magazineTabTitle = "Magazines"
        static let articleTabWidth: CGFloat = 80
        static let magazineTabWidth: CGFloat = 106
        static let loadingIndicatorTopPadding: CGFloat = 180
    }
    
}
