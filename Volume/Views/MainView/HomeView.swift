//
//  HomeView.swift
//  Volume
//
//  Created by Hanzheng Li on 10/26/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var userData: UserData
    @StateObject private var viewModel = ViewModel()

    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = UIColor(Constants.backgroundColor)

        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }

    var body: some View {
        // TODO: refresh viewModel.refreshContent
        List {
            Group {
                trendingArticlesSection
                followedArticlesSection
            }
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            .listRowBackground(Color.clear)
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                Image.volume.logo
                    .foregroundColor(.red)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .modifier(ListBackgroundModifier())
        .background(Constants.backgroundColor)
        .disabled(viewModel.disableScrolling)
        .onAppear {
            viewModel.setup(networkState: networkState, userData: userData)
            viewModel.fetchTrendingArticles()
            viewModel.fetchPage()
        }
    }

    // MARK: Sections

    private var trendingArticlesSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                switch viewModel.trendingArticles {
                case .loading:
                    HStack(spacing: Constants.trendingArticleHorizontalSpacing) {
                        ForEach(0..<2) { _ in
                            BigReadArticleRow.Skeleton()
                        }
                    }
                case .reloading(let articles), .results(let articles):
                    HStack(spacing: Constants.trendingArticleHorizontalSpacing) {
                        ForEach(articles) { article in
                            ZStack {
                                BigReadArticleRow(article: article)
                                NavigationLink("") {
                                    BrowserView(initType: .readyForDisplay(article), navigationSource: .trendingArticles)
                                }.opacity(0)
                            }
                        }
                    }
                }
            }
        } header: {
            Header("The Big Read")
                .padding(.top, 8)
                .foregroundColor(.black)
        }
        .background(headerGradient)
    }

    private var followedArticlesSection: some View {
        Section {
            switch viewModel.followedArticles {
            case .loading:
                if userData.followedPublicationSlugs.isEmpty {
                    VolumeMessage(message: .noFollowingHome, largeFont: false, fullWidth: false)
                        .padding(.top, Constants.volumeMessageTopPadding)
                        .padding(.bottom, Constants.volumeMessageBottomPadding)
                } else {
                    ForEach(0..<5, id: \.self) { _ in
                        ArticleRow.Skeleton()
                            .padding(.vertical, 8)
                    }
                }
            case .reloading(let articles), .results(let articles):
                ForEach(articles) { article in
                    ZStack {
                        ArticleRow(article: article, navigationSource: .followingArticles)
                            .padding(.vertical, 8)// TODO: constant
                            .background {
                                NavigationLink("") {
                                    BrowserView(initType: .readyForDisplay(article), navigationSource: .followingArticles)
                                }
                                .opacity(0)
                            }
                    }
                }

                if viewModel.hasMorePages {
                    ArticleRow.Skeleton()
                        .padding(.vertical, 8)
                        .onAppear {
                            viewModel.fetchPage()
                        }
                } else {
                    VolumeMessage(message: articles.count > 0 ? .upToDate : .noFollowingHome, largeFont: false, fullWidth: false)
                        .padding(.top, Constants.volumeMessageTopPadding)
                        .padding(.bottom, Constants.volumeMessageBottomPadding)
                }
            }
        } header: {
            Header("Following")
                .padding(.top, 8)
                .foregroundColor(.black)
        }
        .background(headerGradient)
    }

    // MARK: Supporting Views

    private var headerGradient: some View {
        LinearGradient(
            colors: [Constants.backgroundColor, Constants.backgroundColor.opacity(0)],
            startPoint: .top, endPoint: .bottom
        )
    }
}

extension HomeView {
    private struct Constants {
        static let verticalSpacing: CGFloat = 20
        static let trendingArticleHorizontalSpacing: CGFloat = 24
        static let volumeMessageTopPadding: CGFloat = 25
        static let volumeMessageBottomPadding: CGFloat = 0
        static let scrollCoordinateSpaceName = "HomeScrollViewCoodinateSpace"

        static var backgroundColor: Color {
            // Prevent inconsistency w/ List background in lower iOS versions
            if #available(iOS 16.0, *) {
                return Color.volume.backgroundGray
            } else {
                return Color.white
            }
        }

        static var headerBackgroundColor: Color {
            backgroundColor.opacity(0.8)
        }
    }
}
