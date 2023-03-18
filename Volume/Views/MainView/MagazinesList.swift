//
//  MagazinesList.swift
//  Volume
//
//  Created by Vin Bui on 3/18/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI
import Combine

struct MagazinesList: View {
    
    @EnvironmentObject private var networkState: NetworkState
    @StateObject private var viewModel = ViewModel()
    
    // MARK: - Constants
    private struct Constants {
        static let navigationTitleKey = "MagazineReaderView"
    }

    // MARK: - UI
    private var featureMagazinesSection: some View {
        Group {
            Header("Featured")
                .padding([.top, .horizontal])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    switch viewModel.sectionStates.featuredMagazines {
                    case .loading, .reloading:
                        ForEach(0..<3) { _ in
                             MagazineCell.Skeleton()
                        }
                    case .results(let results):
                        ForEach(results) { magazine in
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

    private var magazinesBySemesterSection: some View {
        Group {
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
                .padding(.trailing, 16)
                .padding(.top, 8)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    switch viewModel.sectionStates.magazinesBySemester {
                    case .loading, .reloading:
                        ForEach(0..<3) { _ in
                             MagazineCell.Skeleton()
                        }
                    case .results(let results):
                        ForEach(results) { magazine in
                            NavigationLink {
                                MagazineReaderView(initType: .readyForDisplay(magazine), navigationSource: .moreMagazines)
                            } label: {
                                MagazineCell(magazine: magazine)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onChange(of: viewModel.selectedSemester) { newValue in
            guard let selectedSemester = viewModel.selectedSemester else { return }
            if selectedSemester == "all" {
                viewModel.fetchAllMagazines()
            } else {
                viewModel.fetchMagazinesBySemester(selectedSemester)
            }
        }
    }

    private var deepNavigationLink: some View {
        Group {
            if let magazineId = viewModel.deeplinkId {
                NavigationLink(Constants.navigationTitleKey, isActive: $viewModel.openMagazineFromDeeplink) {
                    MagazineReaderView(initType: .fetchRequired(magazineId), navigationSource: .moreMagazines)
                }
                .hidden()
            }
        }
    }

    private var background: some View {
        ZStack {
            Color.volume.backgroundGray
            deepNavigationLink
        }
    }
    
    var body: some View {
        RefreshableScrollView { done in
            if case let .results(magazines) = viewModel.sectionStates.featuredMagazines {
                viewModel.sectionStates.featuredMagazines = .reloading(magazines)
            }
            
            viewModel.sectionStates.magazinesBySemester = .loading
            
            viewModel.fetchContent(done)
        } content: {
            VStack {
                featureMagazinesSection
                Spacer()
                    .frame(height: 16)
                magazinesBySemesterSection
            }
        }
        .disabled(viewModel.sectionStates.featuredMagazines.isLoading)
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
            viewModel.fetchContent()
        }
        .onOpenURL { url in
            if url.isDeeplink,
               url.contentType == .magazine,
               let id = url.parameters["id"] {
                viewModel.deeplinkId = id
                viewModel.openMagazineFromDeeplink = true
            }
        }
    }
    
}
