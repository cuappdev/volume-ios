//
//  FlyersView.swift
//  Volume
//
//  Created by Vin Bui on 4/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FlyersView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var userData: UserData
    @StateObject private var viewModel = ViewModel()
    
    // MARK: - Constants
    
    private struct Constants {
        static let backgroundColor: Color = Color.volume.backgroundGray
        static let dailyButtonSize: CGSize = CGSize(width: 20, height: 20)
        static let dailyCellSize: CGSize = CGSize(width: 340, height: 432)
        static let dailyImageSize: CGSize = CGSize(width: 340, height: 340)
        static let endMessageWidth: CGFloat = 250
        static let gridRows: Array = Array(repeating: GridItem(.flexible()), count: 3)
        static let listHorizontalPadding: CGFloat = 16
        static let rowVerticalPadding: CGFloat = 6
        static let spacing: CGFloat = 16
        static let titleFont: Font = .newYorkMedium(size: 28)
        static let upcomingSectionHeight: CGFloat = 308
        static let volumeMessagePadding: CGFloat = 20
        static let weeklyButtonSize: CGSize = CGSize(width: 15, height: 15)
        static let weeklyCellSize: CGSize = CGSize(width: 256, height: 350)
        static let weeklyImageSize: CGSize = CGSize(width: 256, height: 256)
    }
    
    // MARK: - UI
    
    var body: some View {
        listContent
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                title
            }
        }
        .onAppear {
            viewModel.setupEnvironment(networkState: networkState, userData: userData)
            Task {
                await viewModel.fetchContent()
            }
        }
        .onOpenURL { url in
            // TODO: Handle deep link
        }
    }
    
    private var listContent: some View {
        List {
            Group {
                searchBar
                if let flyers = viewModel.dailyFlyers {
                    !flyers.isEmpty ? todaySection : nil
                }
                if let flyers = viewModel.thisWeekFlyers {
                    !flyers.isEmpty ? thisWeekSection : nil
                }
                upcomingSection
                pastSection                
                endSection
            }
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
        }
        .padding(.top, 8)
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .refreshable {
            await viewModel.refreshContent()
        }
        .modifier(ListBackgroundModifier())
        .background(Constants.backgroundColor)
    }
    
    // MARK: - Sections
    
    private var todaySection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Constants.spacing) {
                    switch viewModel.dailyFlyers {
                    case .none:
                        FlyerCellThisWeek.Skeleton(cellSize: Constants.dailyCellSize, imageSize: Constants.dailyImageSize)
                        FlyerCellThisWeek.Skeleton(cellSize: Constants.dailyCellSize, imageSize: Constants.dailyImageSize)
                        FlyerCellThisWeek.Skeleton(cellSize: Constants.dailyCellSize, imageSize: Constants.dailyImageSize)
                    case .some(let flyers):
                        ForEach(flyers) { flyer in
                            if let urlString = flyer.imageUrl?.absoluteString {
                                FlyerCellThisWeek(
                                    buttonSize: Constants.dailyButtonSize,
                                    cellSize: Constants.dailyCellSize,
                                    flyer: flyer,
                                    imageSize: Constants.dailyImageSize,
                                    organizationNameFont: .newYorkMedium(size: 12),
                                    urlImageModel: URLImageModel(urlString: urlString),
                                    viewModel: viewModel
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, Constants.listHorizontalPadding)
            }
            .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
        } header: {
            Header("Today")
                .padding(.vertical, Constants.rowVerticalPadding)
                .padding(.horizontal, Constants.listHorizontalPadding)
                .foregroundColor(.black)
                .textCase(nil)
        }
        .background(headerGradient)
    }
    
    private var thisWeekSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Constants.spacing) {
                    switch viewModel.thisWeekFlyers {
                    case .none:
                        FlyerCellThisWeek.Skeleton(cellSize: Constants.weeklyCellSize, imageSize: Constants.weeklyImageSize)
                        FlyerCellThisWeek.Skeleton(cellSize: Constants.weeklyCellSize, imageSize: Constants.weeklyImageSize)
                        FlyerCellThisWeek.Skeleton(cellSize: Constants.weeklyCellSize, imageSize: Constants.weeklyImageSize)
                    case .some(let flyers):
                        ForEach(flyers) { flyer in
                            if let urlString = flyer.imageUrl?.absoluteString {
                                FlyerCellThisWeek(
                                    buttonSize: Constants.weeklyButtonSize,
                                    cellSize: Constants.weeklyCellSize,
                                    flyer: flyer,
                                    imageSize: Constants.weeklyImageSize,
                                    organizationNameFont: .newYorkMedium(size: 10),
                                    urlImageModel: URLImageModel(urlString: urlString),
                                    viewModel: viewModel
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, Constants.listHorizontalPadding)
            }
            .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
        } header: {
            Header("This Week")
                .padding(.vertical, Constants.rowVerticalPadding)
                .padding(.horizontal, Constants.listHorizontalPadding)
                .foregroundColor(.black)
                .textCase(nil)
        }
        .background(headerGradient)
    }
    
    private var upcomingSection: some View {
        Section {
            if let flyers = viewModel.upcomingFlyers {
                flyers.isEmpty ? emptyMessage(section: .upcoming) : nil
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: Constants.gridRows, spacing: Constants.spacing) {
                    switch viewModel.upcomingFlyers {
                    case .none:
                        ForEach(0..<6) { _ in
                            FlyerCellUpcoming.Skeleton()
                        }
                    case .some(let flyers):
                        ForEach(flyers) { flyer in
                            if let urlString = flyer.imageUrl?.absoluteString {
                                FlyerCellUpcoming(
                                    flyer: flyer,
                                    navigationSource: .flyersTab,
                                    urlImageModel: URLImageModel(urlString: urlString),
                                    viewModel: viewModel
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, Constants.listHorizontalPadding)
                .frame(height: viewModel.upcomingFlyers?.isEmpty ?? false ? 0 : Constants.upcomingSectionHeight)
            }
            .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
        } header: {
            upcomingHeader
                .padding(.vertical, Constants.rowVerticalPadding)
                .padding(.horizontal, Constants.listHorizontalPadding)
                .foregroundColor(.black)
                .textCase(nil)
        }
        .onChange(of: viewModel.selectedCategory) { _ in
            viewModel.upcomingFlyers = nil
            Task {
                await viewModel.fetchUpcoming()
            }
        }
        .background(headerGradient)
    }
    
    private var upcomingHeader: some View {
        HStack {            
            Header("Upcoming")
            
            Spacer()
            
            Group {
                if let categories = viewModel.allCategories {
                    FlyerCategoryMenu(
                        categories: categories,
                        selected: $viewModel.selectedCategory
                    )
                } else {
                    FlyerCategoryMenu.Skeleton()
                }
            }
        }
    }
    
    private var pastSection: some View {
        Section {
            if let flyers = viewModel.pastFlyers {
                flyers.isEmpty ? emptyMessage(section: .past) : nil
            }
            
            Group {
                switch viewModel.pastFlyers {
                case .none:
                    FlyerCellPast.Skeleton()
                        .padding(.bottom, Constants.spacing)
                    FlyerCellPast.Skeleton()
                case .some(let flyers):
                    ForEach(flyers) { flyer in
                        if let urlString = flyer.imageUrl?.absoluteString {
                            FlyerCellPast(
                                flyer: flyer,
                                navigationSource: .flyersTab,
                                urlImageModel: URLImageModel(urlString: urlString),
                                viewModel: viewModel
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, Constants.listHorizontalPadding)
        } header: {
            Header("Past Flyers")
                .padding(.vertical, Constants.rowVerticalPadding)
                .padding(.horizontal, Constants.listHorizontalPadding)
                .foregroundColor(.black)
                .textCase(nil)
                .edgesIgnoringSafeArea(.all)
        }
        .background(headerGradient)
    }
    
    private var endSection: some View {
        Section {
            Group {
                VolumeMessage(message: .upToDateFlyers, largeFont: false, fullWidth: true)
                    .frame(width: Constants.endMessageWidth)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 40)
            .padding(.bottom, 80)
        }
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
    
    // MARK: - Supporting Views
    
    private var headerGradient: some View {
        LinearGradient(
            colors: [Constants.backgroundColor, Constants.backgroundColor.opacity(0)],
            startPoint: .top, endPoint: .bottom
        )
    }
    
    private var title: some View {
        VStack {
            Rectangle()
                .frame(height: 8)
                .foregroundColor(Constants.backgroundColor)
            
            BubblePeriodText("Flyers")
                .font(Constants.titleFont)
        }
    }
    
    private func emptyMessage(section: FlyerSection) -> some View {
        Group {
            switch section {
            case .past:
                VolumeMessage(image: Image.volume.flyer, message: .noFlyersPast, largeFont: false, fullWidth: false)
            case .upcoming:
                VolumeMessage(image: Image.volume.flyer, message: .noFlyersUpcoming, largeFont: false, fullWidth: false)
            }
        }
        .padding(.top, 2 * Constants.volumeMessagePadding)
        .padding(.bottom, Constants.volumeMessagePadding)
    }
    
}

extension FlyersView {
    
    enum FlyerSection {
        case past, upcoming
    }
    
}

// MARK: - Uncomment below if needed

//struct FlyersView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlyersView()
//    }
//}
