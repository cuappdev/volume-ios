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
    @StateObject var viewModel = ViewModel()

    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = UIColor(Constants.backgroundColor)

        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }

    var body: some View {
        List {
            Group {
                trendingArticlesSection
                weeklyDebriefButton
                followedArticlesSection
                unfollowedArticlesSection
                deepNavigationLink
            }
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: Constants.listHorizontalPadding, bottom: 0, trailing: Constants.listHorizontalPadding))
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
        .refreshable {
            viewModel.fetchContent()
        }
        .modifier(ListBackgroundModifier())
        .background(Constants.backgroundColor)
        .disabled(viewModel.disableScrolling)
        .onAppear {
            viewModel.setupEnvironment(networkState: networkState, userData: userData)
            viewModel.fetchContent()
        }
        .onOpenURL { url in
            viewModel.handleURL(url)
        }
        .sheet(isPresented: $viewModel.isWeeklyDebriefOpen) {
            viewModel.isWeeklyDebriefOpen = false
        } content: {
            weeklyDebriefView
        }
    }

    // MARK: Deeplink

    private var deepNavigationLink: some View {
        // Invisible navigation link
        // Only opens if application is opened through deeplink w/ valid article
        Group {
            if let articleID = viewModel.deeplinkID {
                NavigationLink("", destination: BrowserView(initType: .fetchRequired(articleID), navigationSource: .morePublications), isActive: $viewModel.openArticleFromDeeplink)
            }
        }
    }

    // MARK: Sections

    private var trendingArticlesSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                switch viewModel.trendingArticles {
                case .loading, .reloading:
                    HStack(spacing: Constants.trendingArticleHorizontalSpacing) {
                        ForEach(0..<2) { _ in
                            BigReadArticleRow.Skeleton()
                        }
                    }
                case .results(let articles):
                    HStack(spacing: Constants.trendingArticleHorizontalSpacing) {
                        ForEach(articles) { article in
                            NavigationLink {
                                BrowserView(initType: .readyForDisplay(article), navigationSource: .trendingArticles)
                            } label: {
                                BigReadArticleRow(article: article)
                            }
                        }
                    }
                }
            }
        } header: {
            Header("The Big Read")
                .padding(.vertical, Constants.rowVerticalPadding)
                .foregroundColor(.black)
        }
        .background(headerGradient)
    }

    private var weeklyDebriefButton: some View {
        Group {
            switch viewModel.weeklyDebrief {
            case .loading, .reloading:
                SkeletonView()
            case .results(let weeklyDebrief):
                if let _ = weeklyDebrief {
                    WeeklyDebriefButton(buttonPressed: $viewModel.isWeeklyDebriefOpen)
                }
            }
        }
        .padding(.top, Constants.weeklyDebriefTopPadding)
        .padding(.bottom, Constants.rowVerticalPadding)
    }

    private var weeklyDebriefView: some View {
        Group {
            if let weeklyDebrief = userData.weeklyDebrief {
                WeeklyDebriefView(
                    isOpen: $viewModel.isWeeklyDebriefOpen,
                    onOpenArticleUrl: $viewModel.deeplinkID,
                    openedURL: $viewModel.openArticleFromDeeplink,
                    weeklyDebrief: weeklyDebrief
                )
            }
        }
    }

    private var followedArticlesSection: some View {
        articleSection(followed: true)
    }

    private var unfollowedArticlesSection: some View {
        articleSection(followed: false)
    }

    private func articleSection(followed: Bool) -> some View {
        Section {
            switch followed ? viewModel.followedArticles : viewModel.unfollowedArticles {
            case .loading, .reloading:
                if followed && userData.followedPublicationSlugs.isEmpty {
                    VolumeMessage(message: .noFollowingHome, largeFont: false, fullWidth: false)
                        .padding(.top, Constants.volumeMessageTopPadding)
                        .padding(.bottom, Constants.volumeMessageBottomPadding)
                } else {
                    ForEach(0..<5) { _ in
                        ArticleRow.Skeleton()
                            .padding(.vertical, Constants.rowVerticalPadding)
                    }
                }
            case .results(let articles):
                ForEach(articles) { article in
                    ZStack {
                        ArticleRow(article: article, navigationSource: .followingArticles)
                            .padding(.vertical, Constants.rowVerticalPadding)
                        NavigationLink {
                            BrowserView(initType: .readyForDisplay(article), navigationSource: .followingArticles)
                        } label: {
                            EmptyView()
                        }.opacity(0)
                    }
                }

                if followed ? viewModel.hasMoreFollowedArticlePages : viewModel.hasMoreUnfollowedArticlePages {
                    ArticleRow.Skeleton()
                        .padding(.vertical, Constants.rowVerticalPadding)
                        .onAppear {
                            viewModel.fetchPage(followed: followed)
                        }
                } else if followed {
                    VolumeMessage(message: articles.count > 0 ? .upToDate : .noFollowingHome, largeFont: false, fullWidth: false)
                        .padding(.top, Constants.volumeMessageTopPadding)
                        .padding(.bottom, Constants.volumeMessageBottomPadding)
                        .onAppear {
                            viewModel.fetchPage(followed: false)
                        }
                }
            }
        } header: {
            Header(followed ? Constants.followedArticlesSectionTitle : Constants.unfollowedArticlesSectionTitle)
                .padding(.vertical, Constants.rowVerticalPadding)
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
        static let listHorizontalPadding: CGFloat = 16
        static let rowVerticalPadding: CGFloat = 6
        static let weeklyDebriefTopPadding: CGFloat = 24
        static let trendingArticleHorizontalSpacing: CGFloat = 24
        static let volumeMessageTopPadding: CGFloat = 25
        static let volumeMessageBottomPadding: CGFloat = 0
        static let followedArticlesSectionTitle: String = "Following"
        static let unfollowedArticlesSectionTitle: String = "Other Articles"

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
