//
//  ArticlesView.swift
//  Volume
//
//  Created by Vin Bui on 4/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ArticlesView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var userData: UserData
    @StateObject var viewModel = ViewModel()
    
    // MARK: - Constants
    
    private struct Constants {
        static let followedArticlesSectionTitle: String = "Following"
        static let listHorizontalPadding: CGFloat = 16
        static let rowVerticalPadding: CGFloat = 6
        static let trendingArticleHorizontalSpacing: CGFloat = 24
        static let unfollowedArticlesSectionTitle: String = "Other Articles"
        static let volumeMessageBottomPadding: CGFloat = 0
        static let volumeMessageTopPadding: CGFloat = 25
        static let weeklyDebriefTopPadding: CGFloat = 24
        
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
    
    // MARK: - UI
    
    var body: some View {
        ZStack {
            background.edgesIgnoringSafeArea(.all)
            listContent
            .onAppear {
                viewModel.setupEnvironment(networkState: networkState, userData: userData)
                Task {
                    await viewModel.fetchContent()
                }
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
    }
    
    private var listContent: some View {
        List {
            Group {
                searchBar
                trendingArticlesSection
                weeklyDebriefButton
                followedArticlesSection
                unfollowedArticlesSection
            }
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
        }
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .refreshable {
            await viewModel.refreshContent()
        }
        .modifier(ListBackgroundModifier())
        .background(background)
        .disabled(viewModel.disableScrolling)
    }
    
    private var searchBar: some View {
        SearchBar(searchState: $viewModel.searchState, searchText: $viewModel.searchText)
            .disabled(true)
            .overlay(NavigationLink(destination: SearchView(), label: {
                EmptyView()
            }).opacity(0))
            .padding(.horizontal, Constants.listHorizontalPadding)
            .padding(.top, 5)
    }
    
    // MARK: - Sections
    
    private var trendingArticlesSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                switch viewModel.trendingArticles {
                case .none:
                    HStack(spacing: Constants.trendingArticleHorizontalSpacing) {
                        ForEach(0..<2) { _ in
                            BigReadArticleRow.Skeleton()
                        }
                    }
                case .some(let articles):
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
            .padding(.horizontal, Constants.listHorizontalPadding)
            .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
        } header: {
            Header("The Big Read")
                .padding(.vertical, Constants.rowVerticalPadding)
                .padding(.horizontal, Constants.listHorizontalPadding)
                .foregroundColor(.black)
                .textCase(nil)
        }
        .background(headerGradient)
    }
    
    private var followedArticlesSection: some View {
        articleSection(followed: true)
    }

    private var unfollowedArticlesSection: some View {
        articleSection(followed: false)
    }

    private func articleSection(followed: Bool) -> some View {
        Section {
            Group {
                switch followed ? viewModel.followedArticles : viewModel.unfollowedArticles {
                case .none:
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
                case .some(let articles):
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
                                // scrolled to last loaded row, fetch more rows
                                viewModel.fetchPage(followed: followed)
                            }
                    } else if followed {
                        VolumeMessage(message: articles.count > 0 ? .upToDateArticles : .noFollowingHome, largeFont: false, fullWidth: false)
                            .padding(.top, Constants.volumeMessageTopPadding)
                            .padding(.bottom, Constants.volumeMessageBottomPadding)
                            .onAppear {
                                viewModel.fetchPage(followed: false)
                            }
                    }
                }
            }
            .padding(.horizontal, Constants.listHorizontalPadding)
            .padding(.bottom)
        } header: {
            Header(followed ? Constants.followedArticlesSectionTitle : Constants.unfollowedArticlesSectionTitle)
                .padding(.vertical, Constants.rowVerticalPadding)
                .padding(.horizontal, Constants.listHorizontalPadding)
                .foregroundColor(.black)
                .textCase(nil)
        }
        .background(headerGradient)
    }
    
    // MARK: - Weekly Debrief
    
    private var weeklyDebriefButton: some View {
        Group {
            if viewModel.weeklyDebrief != nil {
                WeeklyDebriefButton(buttonPressed: $viewModel.isWeeklyDebriefOpen)
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
    
    // MARK: - Supporting Views
    
    private var headerGradient: some View {
        LinearGradient(
            colors: [Constants.backgroundColor, Constants.backgroundColor.opacity(0)],
            startPoint: .top, endPoint: .bottom
        )
    }

    private var background: some View {
        ZStack {
            Constants.backgroundColor
        }
    }
}

// MARK: Uncomment below if needed

//struct ArticlesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArticlesView()
//    }
//}
