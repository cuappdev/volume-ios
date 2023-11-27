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

    enum FlyerSection {
        case past
        case upcoming
    }

    // MARK: - Constants

    private struct Constants {
        static let articlesTabWidth: CGFloat = 80
        static let dropdownWidth: CGFloat = 128
        static let flyerSpacing: CGFloat = 16
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
            Task {
                await viewModel.fetchContent()
            }
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
        VStack {
            if let upcomingFlyers = viewModel.upcomingFlyers,
               let pastFlyers = viewModel.pastFlyers {

                if pastFlyers.isEmpty && upcomingFlyers.isEmpty {
                    // No past and upcoming
                    noSavedContentView
                } else if pastFlyers.isEmpty {
                    // No past only
                    flyerSection(.upcoming)
                } else if upcomingFlyers.isEmpty {
                    // No upcoming only
                    flyerSection(.past)
                } else {
                    // Both upcoming and past
                    flyerSection(.upcoming)
                    flyerSection(.past)
                }
            }
        }
    }

    private func flyerSection(_ flyerSection: FlyerSection) -> some View {
        Section {
            let selectedFlyers = (flyerSection == .upcoming) ? viewModel.upcomingFlyers : viewModel.pastFlyers

            Group {
                switch selectedFlyers {
                case .none:
                    ForEach(0..<4) { _ in
                        FlyerCellPast.Skeleton()
                    }
                case .some(let flyers):
                    ForEach(flyers) { flyer in
                        FlyerCellPast(
                            flyer: flyer,
                            navigationSource: .bookmarkFlyers,
                            urlImageModel: URLImageModel(urlString: flyer.imageUrl?.absoluteString ?? ""),
                            viewModel: FlyersView.ViewModel()
                        )
                    }
                }
            }
            .padding(.bottom, Constants.flyerSpacing)
        } header: {
            flyerSectionHeader(for: flyerSection)
        }
        .onChange(of: viewModel.selectedUpcomingCategory) { _ in
            viewModel.filterUpcoming()
        }
        .onChange(of: viewModel.selectedPastCategory) { _ in
            viewModel.filterPast()
        }
        .padding(.horizontal, Constants.sidePadding)
    }

    private func flyerSectionHeader(for flyerSection: FlyerSection) -> some View {
        HStack {
            Header(flyerSection == .upcoming ? "Upcoming" : "Past Flyers")

            Spacer()

            CategoryDropdown(
                categories: flyerSection == .upcoming
                    ? viewModel.upcomingCategories
                    : viewModel.pastCategories,
                defaultSelected: ViewModel.Constants.defaultCategory,
                selected: flyerSection == .upcoming
                    ? $viewModel.selectedUpcomingCategory
                    : $viewModel.selectedPastCategory
            )
            .frame(maxWidth: Constants.dropdownWidth)
        }
        .padding(.bottom, 4)
        .foregroundStyle(.black)
        .textCase(nil)
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
                VolumeMessage(
                    image: Image.volume.flyer,
                    message: .noBookmarkedFlyers,
                    largeFont: true,
                    fullWidth: true
                )
            case .articles:
                VolumeMessage(
                    image: Image.volume.feed,
                    message: .noBookmarkedArticles,
                    largeFont: true,
                    fullWidth: true
                )
            case .magazines:
                VolumeMessage(
                    image: Image.volume.magazine,
                    message: .noBookmarkedMagazines,
                    largeFont: true,
                    fullWidth: true
                )
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
