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
    @StateObject private var viewModel = ViewModel()
    
    // MARK: - Constants
    
    private struct Constants {
        static let backgroundColor: Color = Color.volume.backgroundGray
        static let gridRows: Array = Array(repeating: GridItem(.flexible()), count: 3)
        static let listHorizontalPadding: CGFloat = 16
        static let rowVerticalPadding: CGFloat = 6
        static let spacing: CGFloat = 16
        static let titleFont: Font = .newYorkMedium(size: 28)
        static let upcomingSectionHeight: CGFloat = 308
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
            // TODO: Setup Environment and Fetch First Load
        }
        .onOpenURL { url in
            // TODO: Handle deep link
        }
    }
    
    private var listContent: some View {
        List {
            Group {
                thisWeekSection
                upcomingSection
                pastSection
            }
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: Constants.listHorizontalPadding, bottom: 0, trailing: Constants.listHorizontalPadding))
            .listRowBackground(Color.clear)
        }
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .refreshable {
            // TODO: RefreshContent
        }
        .modifier(ListBackgroundModifier())
        .background(Constants.backgroundColor)
        .disabled(viewModel.disableScrolling)
    }
    
    // MARK: - Sections
    
    private var thisWeekSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Constants.spacing) {
                    switch viewModel.thisWeekFlyers {
                    case .none:
                        FlyerCellThisWeek.Skeleton()
                        FlyerCellThisWeek.Skeleton()
                        FlyerCellThisWeek.Skeleton()
                    case .some(let flyers):
                        SkeletonView()
                    }
                }
            }
        } header: {
            Header("This Week")
                .padding(.vertical, Constants.rowVerticalPadding)
                .foregroundColor(.black)
                .textCase(nil)
        }
        .background(headerGradient)
    }
    
    private var upcomingSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: Constants.gridRows, spacing: Constants.spacing) {
                    switch viewModel.upcomingFlyers {
                    case .none:
                        ForEach(0..<6) { _ in
                            FlyerCellUpcoming.Skeleton()
                        }
                    case .some(let flyers):
                        FlyerCellUpcoming.Skeleton()
                    }
                }
                .frame(height: Constants.upcomingSectionHeight)
            }
        } header: {
            upcomingHeader
                .padding(.vertical, Constants.rowVerticalPadding)
                .foregroundColor(.black)
                .textCase(nil)
        }
        .background(headerGradient)
    }
    
    private var upcomingHeader: some View {
        HStack {            
            Header("Upcoming")
            
            // TODO: Add Filter
            Spacer()
        }
    }
    
    private var pastSection: some View {
        Section {
            switch viewModel.pastFlyers {
            case .none:
                FlyerCellPast.Skeleton()
                    .padding(.bottom, Constants.spacing)
                FlyerCellPast.Skeleton()
            case .some(let flyers):
                SkeletonView()
            }
        } header: {
            Header("Past Flyers")
                .padding(.vertical, Constants.rowVerticalPadding)
                .foregroundColor(.black)
                .textCase(nil)
        }
        .background(headerGradient)
    }
    
    // MARK: - Supporting Views
    
    private var headerGradient: some View {
        LinearGradient(
            colors: [Constants.backgroundColor, Constants.backgroundColor.opacity(0)],
            startPoint: .top, endPoint: .bottom
        )
    }
    
    private var title: some View {
        BubblePeriodText("Flyers")
            .font(Constants.titleFont)
            .offset(y: 8)
            .padding(.bottom)
    }
    
}

// MARK: - Uncomment below if needed

struct FlyersView_Previews: PreviewProvider {
    static var previews: some View {
        FlyersView()
    }
}
