//
//  BookmarksView.swift
//  Volume
//
//  Created by Vin Bui on 4/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct BookmarksView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var userData: UserData
    @StateObject private var viewModel = ViewModel()
    
    // MARK: - Constants
    
    private struct Constants {
        static let articlesTabWidth: CGFloat = 80
        static let flyersTabWidth: CGFloat = 70
        static let magazinesTabWidth: CGFloat = 110
        static let noSavedMessageLength: CGFloat = 250
        static let sidePadding: CGFloat = 16
        static let titleFont: Font = .newYorkMedium(size: 28)
    }
    
    // MARK: - UI
    
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
            .font(Constants.titleFont)
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
        .simultaneousGesture(
            TapGesture().onEnded {
                Haptics.shared.play(.light)
            }
        )
    }
    
    private var tabBar: some View {
        ContentFilterBarView(selectedTab: $viewModel.selectedTab)
    }
    
    private var scrollContent: some View {
        Group {
            switch viewModel.selectedTab {
            case .flyers:
                flyerContent
            case .articles:
                articleContent
            case .magazines:
                magazineContent
            }
        }
        .padding(.top)
    }
    
    // MARK: - Sections
    
    private var flyerContent: some View {
        Group {
            if viewModel.hasSavedFlyers {
                switch viewModel.flyers {
                case .none:
                    ForEach(0..<4) { _ in
                        FlyerCellPast.Skeleton()
                            .padding(.bottom, 16)
                    }
                case .some(let flyers):
                    ForEach(flyers) { flyer in
                        if let urlString = flyer.imageUrl?.absoluteString {
                            FlyerCellPast(
                                flyer: flyer,
                                urlImageModel: URLImageModel(urlString: urlString),
                                viewModel: FlyersView.ViewModel()
                            )
                        }
                    }
                }
            } else {
                noSavedContentView
            }
        }
        .padding(.horizontal, Constants.sidePadding)
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
            Spacer(minLength: Constants.noSavedMessageLength)
            
            switch viewModel.selectedTab {
            case .flyers:
                VolumeMessage(image: Image.volume.flyer, message: .noBookmarkedFlyers, largeFont: true, fullWidth: true)
            case .articles:
                VolumeMessage(image: Image.volume.feed, message: .noBookmarkedArticles, largeFont: true, fullWidth: true)
            case .magazines:
                VolumeMessage(image: Image.volume.magazine, message: .noBookmarkedMagazines, largeFont: true, fullWidth: true)
            }
        }
    }
    
}

// MARK: Uncomment below if needed

//struct BookmarksView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookmarksView()
//    }
//}
