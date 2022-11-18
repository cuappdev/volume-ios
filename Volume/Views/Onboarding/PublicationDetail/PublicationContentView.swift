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
        VStack(alignment: .leading) {
            tabBar
            TabView(selection: $viewModel.selectedTab) {
                articleTab
                    .tag(PublicationContentType.articles)
                magazineTab
                    .tag(PublicationContentType.magazines)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color.clear)
        }
        .onAppear {
            viewModel.setupEnvironmentVariables(networkState: networkState)
            viewModel.fetchContent()
        }
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabBarItem(title: Constants.articleTabTitle, tab: .articles)
                .frame(width: 80)
            tabBarItem(title: Constants.magazineTabTitle, tab: .magazines)
                .frame(width: 106)
            Spacer()
        }
        .padding(.horizontal)
    }

    private func tabBarItem(title: String, tab: PublicationContentType) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .font(.newYorkMedium(size: 18))
                .foregroundColor(viewModel.selectedTab == tab ? Color.volume.orange : .black)
                .padding(.top)

            if viewModel.selectedTab == tab {
                Color.volume.orange
                    .frame(height: 2)
                    .matchedGeometryEffect(
                        id: "underline",
                        in: namespace,
                        properties: .frame
                    )
            } else {
                Color.volume.veryLightGray
                    .frame(height: 2)
            }
        }
        .animation(.spring(), value: viewModel.selectedTab)
        .onTapGesture {
            viewModel.selectedTab = tab
        }
    }

    private var articleTab: some View {
        // HAN TODO: detect scroll in middle, top, add gradient when middle
        ScrollView(viewModel.disableScrolling ? [] : .vertical) {
            LazyVStack {
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
                            .padding([.horizontal, .bottom])
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
            .padding(.top)
        }
    }

    private var magazineTab: some View {
        Text("magazines!")
    }

    // MARK: Helpers

    private var articleRowSkeleton: some View {
        ArticleRow.Skeleton(showsPublicationName: false)
            .padding([.horizontal, .bottom])
    }
}

extension PublicationContentView {

    private struct Constants {
        // HAN TODO: add to constnats
        static let articleTabTitle = "Articles"
        static let magazineTabTitle = "Magazines"
    }
}
