//
//  MagazinesList.swift
//  Volume
//
//  Created by Vin Bui on 3/23/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct MagazinesList: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var networkState: NetworkState
    @StateObject private var viewModel = ViewModel()
    
    // MARK: - UI Constants
    
    private struct Constants {
        static let gridColumns: Array = Array(repeating: GridItem(.flexible()), count: 2)
        static let groupTopPadding: CGFloat = 8
        static let magazineHorizontalSpacing: CGFloat = 24
        static let magazineVerticalSpacing: CGFloat = 30
        static let navigationTitleKey = "MagazineReaderView"
        static let sidePadding: CGFloat = 16
    }
    
    // MARK: - UI
    
    var body: some View {
        RefreshableScrollView { done in
            viewModel.refreshContent(done)
        } content: {
            VStack {
                featuredMagazinesSection
                Spacer()
                    .frame(height: Constants.groupTopPadding)
                moreMagazinesSection
            }
        }
        .padding(.top)
        .background(background)
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                BubblePeriodText("Magazines")
                    .font(.newYorkMedium(size: 28))
                    .offset(y: 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.networkState = networkState
            Task {
                await viewModel.fetchContent()
            }
        }
        .onOpenURL { url in
            if url.isDeeplink,
               url.contentType == .magazine,
               let id = url.parameters["id"] {
                viewModel.deeplinkID = id
                viewModel.openMagazineFromDeeplink = true
            }
        }
    }
    
    private var featuredMagazinesSection: some View {
        Group {
            Header("Featured")
                .padding([.top, .horizontal])
            
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
                                MagazineReaderView(initType: .readyForDisplay(magazine), navigationSource: .featuredMagazines)
                            } label: {
                                MagazineCell(magazine: magazine)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var moreMagazinesSection: some View {
        Group {
            moreMagazinesHeader
            
            LazyVGrid(columns: Constants.gridColumns, spacing: Constants.magazineVerticalSpacing) {
                switch viewModel.moreMagazines {
                case .none:
                    ForEach(0..<2) { _ in
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
                            viewModel.fetchNextPage()
                        }
                    }
                }
            }
            .padding(.bottom)
        }
        .padding(.top)
        .onChange(of: viewModel.selectedSemester) { _ in
            viewModel.fetchMoreMagazinesSection()
        }
    }
    
    private var moreMagazinesHeader: some View {
        HStack(alignment: .center) {
            Header("More magazines")
                .padding([.top, .horizontal])

            Group {
                if let options = viewModel.allSemesters {
                    SemesterMenuView(
                        selection: $viewModel.selectedSemester,
                        options: options
                    )
                } else {
                    SemesterMenuView.Skeleton()
                }
            }
            .padding(.trailing, Constants.sidePadding)
            .padding(.top)
        }
    }
    
    // MARK: - Supporting Views
    private var background: some View {
        ZStack {
            Color.volume.backgroundGray
            deepNavigationLink
        }
    }
    
    private var deepNavigationLink: some View {
        Group {
            if let magazineID = viewModel.deeplinkID {
                NavigationLink(Constants.navigationTitleKey, isActive: $viewModel.openMagazineFromDeeplink) {
                    MagazineReaderView(initType: .fetchRequired(magazineID), navigationSource: .moreMagazines)
                }
                .hidden()
            }
        }
    }
    
}
// MARK: Uncomment below if needed

//struct MagazinesList_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazinesList()
//            .environmentObject(NetworkState())
//    }
//}
