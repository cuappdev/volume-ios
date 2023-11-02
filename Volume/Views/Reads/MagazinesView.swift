//
//  MagazinesView.swift
//  Volume
//
//  Created by Vin Bui on 3/23/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct MagazinesView: View {

    // MARK: - Properties

    @EnvironmentObject private var networkState: NetworkState
    @StateObject private var viewModel = ViewModel()

    // MARK: - UI Constants

    private struct Constants {
        static let gridColumns: Array = Array(repeating: GridItem(.flexible()), count: 2)
        static let groupTopPadding: CGFloat = 8
        static let magazineHorizontalSpacing: CGFloat = 24
        static let magazineVerticalSpacing: CGFloat = 30
        static let searchTop: CGFloat = 5
        static let sidePadding: CGFloat = 16

        static var backgroundColor: Color {
            // Prevent inconsistency w/ List background in lower iOS versions
            if #available(iOS 16.0, *) {
                return Color.volume.backgroundGray
            } else {
                return Color.white
            }
        }
    }

    // MARK: - UI

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Constants.groupTopPadding * 2, pinnedViews: [.sectionHeaders]) {
                searchBar

                if viewModel.featuredMagazines != nil && viewModel.featuredMagazines?.count != 0 {
                    featuredMagazinesSection
                }

                Spacer()
                    .frame(height: Constants.groupTopPadding)

                moreMagazinesSection
            }
        }
        .background(Color.volume.backgroundGray)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.networkState = networkState
            Task {
                await viewModel.fetchContent()
            }
        }
        .refreshable {
            Task {
                await viewModel.refreshContent()
            }
        }
    }

    private var searchBar: some View {
        NavigationLink {
            SearchView()
        } label: {
            SearchBar(searchState: $viewModel.searchState, searchText: $viewModel.searchText)
                .disabled(true)
                .padding(
                    EdgeInsets(
                        top: Constants.searchTop,
                        leading: Constants.sidePadding,
                        bottom: 0,
                        trailing: Constants.sidePadding
                    )
                )
        }
    }

    private var featuredMagazinesSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Constants.magazineHorizontalSpacing) {
                    switch viewModel.featuredMagazines {
                    case .none:
                        ForEach(0..<3) { _ in
                            MagazineCell.Skeleton()
                        }
                    case .some(let magazines):
                        ForEach(magazines) { magazine in
                            NavigationLink {
                                MagazineReaderView(
                                    initType: .readyForDisplay(magazine),
                                    navigationSource: .featuredMagazines
                                )
                            } label: {
                                MagazineCell(magazine: magazine)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            // swiftlint:disable:next force_cast
            .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
        } header: {
            Header("Featured")
                .padding(.vertical, Constants.groupTopPadding)
                .background(Constants.backgroundColor)
        }
        .padding(.horizontal, Constants.sidePadding)
    }

    private var moreMagazinesSection: some View {
        Section {
            LazyVGrid(columns: Constants.gridColumns, spacing: Constants.magazineVerticalSpacing) {
                switch viewModel.moreMagazines {
                case .none:
                    ForEach(0..<4) { _ in
                        MagazineCell.Skeleton()
                    }
                case .some(let magazines):
                    ForEach(magazines) { magazine in
                        NavigationLink {
                            MagazineReaderView(initType: .readyForDisplay(magazine), navigationSource: .moreMagazines)
                        } label: {
                            MagazineCell(magazine: magazine)
                        }
                    }

                    if viewModel.hasMoreMagazines {
                        ForEach(0..<2) { _ in
                            MagazineCell.Skeleton()
                        }
                        .onAppear {
                            Task {
                                await viewModel.fetchNextPage()
                            }
                        }
                    }
                }
            }
            .padding(.bottom)
        } header: {
            moreMagazinesHeader
        }
        .padding(.horizontal, Constants.sidePadding)
        .onChange(of: viewModel.selectedSemester) { _ in
            Task {
                await viewModel.fetchMoreMagazinesSection()
            }
        }
    }

    private var moreMagazinesHeader: some View {
        HStack(alignment: .center) {
            Header("More magazines")

            if let options = viewModel.allSemesters {
                SemesterMenuView(
                    selection: $viewModel.selectedSemester,
                    options: options
                )
            } else {
                SemesterMenuView.Skeleton()
            }
        }
        .padding(.vertical, Constants.groupTopPadding)
        .background(Constants.backgroundColor)
    }
}

//struct MagazinesList_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazinesList()
//            .environmentObject(NetworkState())
//    }
//}
