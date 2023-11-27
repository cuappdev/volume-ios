//
//  OrganizationContentView.swift
//  Volume
//
//  Created by Vin Bui on 11/17/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct OrganizationContentView: View {

    // MARK: - Properties

    let navigationSource: NavigationSource
    let organization: Organization

    @Namespace private var namespace
    @EnvironmentObject private var networkState: NetworkState
    @StateObject private var viewModel = ViewModel()

    // MARK: - Constants

    private struct Constants {
        static let sidePadding: CGFloat = 16
        static let spacing: CGFloat = 16
    }

    // MARK: - UI

    var body: some View {
        Group {
            switch viewModel.flyers {
            case .none:
                loadingView
            case .some(let flyers):
                if flyers.count == 0 {
                    emptyStateMessage
                } else {
                    flyerContent
                }
            }
        }
        .onAppear {
            viewModel.setupEnvironmentVariables(networkState: networkState, organization: organization)
            Task {
                await viewModel.fetchFlyersPage()
            }
        }
    }

    private var loadingView: some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 180)

            ProgressView()
        }
    }

    private var flyerContent: some View {
        LazyVStack(alignment: .leading, spacing: Constants.spacing) {
            Header("Flyers")

            switch viewModel.flyers {
            case .none:
                ForEach(0..<5) { _ in
                    FlyerCellUpcoming.Skeleton()
                }
            case .some(let flyers):
                ForEach(flyers) { flyer in
                    FlyerCellUpcoming(
                        flyer: flyer,
                        navigationSource: navigationSource,
                        urlImageModel: URLImageModel(urlString: flyer.imageUrl?.absoluteString ?? ""),
                        viewModel: FlyersView.ViewModel()
                    )
                    .onAppear {
                        viewModel.fetchPageIfLast(flyer: flyer)
                    }
                }

                if viewModel.hasMorePages {
                    FlyerCellUpcoming.Skeleton()
                }
            }
        }
        .padding(.horizontal, Constants.sidePadding)
    }

    // MARK: - Supporting Views

    private var emptyStateMessage: some View {
        VStack {
            Header("Flyers")

            VolumeMessage(
                message: .noFlyersOrgDetail,
                largeFont: false,
                fullWidth: false
            )
            .padding(.top, 128)
        }
        .padding(.horizontal, Constants.sidePadding)
    }

}
