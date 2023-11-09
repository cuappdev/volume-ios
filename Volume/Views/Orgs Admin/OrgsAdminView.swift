//
//  OrgsAdminView.swift
//  Volume
//
//  Created by Vin Bui on 11/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

struct OrgsAdminView: View {

    // MARK: - Properties

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var networkState: NetworkState
    @StateObject private var viewModel = ViewModel()

    let organization: Organization?

    // MARK: - Constants

    private struct Constants {
        static let pastTabWidth: CGFloat = 64
        static let sectionSpacing: CGFloat = 24
        static let sidePadding: CGFloat = 16
        static let topPadding: CGFloat = 28
        static let upcomingTabWidth: CGFloat = 96
    }

    // MARK: - UI

    var body: some View {
        ZStack(alignment: .center) {
            mainContent

            if viewModel.showSpinner {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(Color.volume.backgroundGray)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Organization Home")
                    .font(.newYorkMedium(size: 20))
            }

            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image.volume.backArrow
                        .foregroundColor(Color.black)
                }
                .buttonStyle(EmptyButtonStyle())
            }
        }
        .onAppear {
            guard let organization = organization else { return }

            viewModel.setupEnvironment(networkState: networkState)
            Task {
                await viewModel.refreshContent(for: organization)
            }
        }
        .onChange(of: viewModel.selectedTab) { _ in
            viewModel.filterContentSelection()
        }
        .refreshable {
            guard let organization = organization else { return }

            Task {
                await viewModel.refreshContent(for: organization)
            }
        }
    }

    private var mainContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                titleUploadSection
                slidingTabBar
                flyersSection

                Spacer()
            }
            .padding(.top, Constants.topPadding)
            .padding(.horizontal, Constants.sidePadding)
        }
    }

    private var titleUploadSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(organization?.name ?? "")
                .font(.newYorkMedium(size: 24))

            uploadFlyerButton
        }
    }

    private var uploadFlyerButton: some View {
        NavigationLink {
            FlyerUploadView(isEditing: false, organization: organization)
        } label: {
            VStack(alignment: .center, spacing: 8) {
                Image.volume.upload
                    .frame(width: 24, height: 24)

                Text("Upload a New Flyer")
                    .font(.helveticaNeueMedium(size: 16))
                    .foregroundStyle(Color.volume.orange)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(Color.volume.orange.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.volume.orange.opacity(0.2), lineWidth: 1)
            )
        }
    }

    private var slidingTabBar: some View {
        SlidingTabBarView(
            selectedTab: $viewModel.selectedTab,
            items: [
                SlidingTabBarView.Item(
                    title: "Upcoming",
                    tab: .upcoming,
                    width: Constants.upcomingTabWidth
                ),
                SlidingTabBarView.Item(
                    title: "Past",
                    tab: .past,
                    width: Constants.pastTabWidth
                )
            ].compactMap { $0 },
            addSidePadding: false,
            font: .newYorkRegular(size: 16),
            selectedColor: Color.black,
            unselectedColor: Color.volume.lightGray
        )
    }

    @MainActor
    private var flyersSection: some View {
        LazyVStack(alignment: .leading, spacing: 16) {
            flyersSectionTitle

            switch viewModel.displayedFlyers {
            case .none:
                ForEach(0..<3) { _ in
                    OrgFlyerCellView.Skeleton()
                }
            case .some(let flyers):
                if flyers.isEmpty {
                    flyersEmptyState
                } else {
                    ForEach(flyers) { flyer in
                        if let urlString = flyer.imageUrl?.absoluteString {
                            OrgFlyerCellView(
                                flyer: flyer,
                                navigationSource: .orgsAdmin,
                                urlImageModel: URLImageModel(urlString: urlString),
                                viewModel: viewModel
                            )
                        }
                    }
                }
            }
        }
    }

    // MARK: - Supporting Views

    private var flyersSectionTitle: some View {
        Group {
            switch viewModel.selectedTab {
            case .past:
                Text("Past Flyers")
            case .upcoming:
                Text("Upcoming Flyers")
            }
        }
        .font(.newYorkMedium(size: 20))
    }

    private var flyersEmptyState: some View {
        VolumeMessage(
            image: Image.volume.flyer,
            message: .noFlyersOrgAdmin,
            largeFont: false,
            fullWidth: false
        )
        .padding(.top, 24)
    }

}

// MARK: - Uncomment below if needed

//
//#Preview {
//    OrgsAdminView()
//}
