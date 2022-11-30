//
//  BookmarksView.swift
//  Volume
//
//  Created by Hanzheng Li on 11/18/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var userData: UserData
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            tabBar
            ScrollView {
                scrollContent
            }
        }
        .background(Color.volume.backgroundGray)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                title
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                settingsButton
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.setupEnvironmentVariables(networkState: networkState, userData: userData)
            viewModel.fetchContent()
        }
    }

    private var title: some View {
        BubblePeriodText("Bookmarks")
            .font(.newYorkMedium(size: 28))
            .offset(y: 8)
    }

    private var settingsButton: some View {
        NavigationLink {
            SettingsView()
        } label: {
            Image.volume.settings
                .offset(x: -5, y: 5)
                .buttonStyle(PlainButtonStyle())
        }
    }

    private var tabBar: some View {
        SlidingTabBarView(
            selectedTab: $viewModel.selectedTab,
            items: [
                SlidingTabBarView.Item(
                    title: "Articles",
                    tab: .articles,
                    width: 80
                ),
                SlidingTabBarView.Item(
                    title: "Magazines",
                    tab: .magazines,
                    width: 106
                )
            ]
        )
    }

    private var scrollContent: some View {
        Group {
            switch viewModel.selectedTab {
            case .articles:
                articleContent
            case .magazines:
                magazineContent
            }
        }
        .padding(.top)
    }

    private var articleContent: some View {
        Group {
            if viewModel.hasSavedArticles {
                switch viewModel.articles {
                case .none:
                    ForEach(0..<10) { _ in
                        ArticleRow.Skeleton()
                            .padding([.bottom, .leading, .trailing])
                    }
                case .some(let articles):
                    LazyVStack {
                        ForEach(articles) { article in
                            NavigationLink {
                                BrowserView(
                                    initType: .readyForDisplay(article),
                                    navigationSource: .bookmarkArticles
                                )
                            } label: {
                                ArticleRow(article: article, navigationSource: .bookmarkArticles)
                                    .padding([.bottom, .horizontal])
                            }
                        }
                    }
                }
            } else {
                noSavedContentView
            }
        }
    }

    private var magazineContent: some View {
        Group {
            if viewModel.hasSavedMagazines {
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
            } else {
                noSavedContentView
            }
        }
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
            MagazineReaderView(initType: .readyForDisplay(magazine), navigationSource: .bookmarkMagazines)
        } label: {
            MagazineCell(magazine: magazine)
        }
    }

    private var noSavedContentView: some View {
        VStack {
            Spacer(minLength: 250)
            VolumeMessage(message: .noBookmarks, largeFont: true, fullWidth: true)
        }
    }
}
