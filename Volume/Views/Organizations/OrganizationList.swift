//
//  OrganizationList.swift
//  Volume
//
//  Created by Vin Bui on 11/16/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct OrganizationList: View {

    // MARK: - Properties

    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var userData: UserData
    @StateObject private var viewModel = ViewModel()

    // MARK: - Constants

    private struct Constants {
        static let colSpacing: CGFloat = 12
        static let rowSpacing: CGFloat = 16
        static let sidePadding: CGFloat = 16
    }

    // MARK: - UI

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                followedOrgsSection

                EmptyView()
                    .frame(height: 16)

                moreOrgsSection
            }
        }
        .padding(.top)
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            viewModel.refreshContent()
        }
        .disabled(viewModel.followedOrgs == nil && viewModel.unfollowedOrgs == nil)
        .onAppear {
            viewModel.setupEnvironmentVariables(networkState: networkState, userData: userData)

            Task {
                await viewModel.fetchAllOrganizations()
            }
        }
    }

    private var followedOrgsSection: some View {
        Section {
            followedOrgsScrollView
        } header: {
            Header("Following")
                .padding([.leading, .top, .trailing])
                .padding(.bottom, 6)
        }
    }

    private var followedOrgsScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Constants.colSpacing) {
                switch viewModel.followedOrgs {
                case .none:
                    ForEach(0..<4, id: \.self) { _ in
                        FollowingOrganizationRow.Skeleton()
                    }
                case .some(let orgs):
                    if orgs.isEmpty {
                        noFollowedOrgsMessage
                    } else {
                        ForEach(orgs) { org in
                            NavigationLink {
                                OrganizationDetail(
                                    navigationSource: .flyersTab,
                                    organization: org
                                )
                            } label: {
                                FollowingOrganizationRow(organization: org)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, Constants.sidePadding)
        }
        .disabled(!viewModel.hasFollowedOrganizations)
    }

    private var moreOrgsSection: some View {
        Section {
            LazyVStack {
                switch viewModel.unfollowedOrgs {
                case .none:
                    ForEach(0..<5) { _ in
                        MorePublicationRow.Skeleton()
                            .padding(.bottom, 15)
                    }
                case .some(let orgs):
                    ForEach(orgs) { org in
                        NavigationLink {
                            OrganizationDetail(
                                navigationSource: .flyersTab,
                                organization: org
                            )
                        } label: {
                            MoreOrganizationRow(organization: org, navigationSource: .flyersTab)
                                .padding(.bottom, Constants.rowSpacing)
                        }
                    }
                }
            }
            .padding(.horizontal, Constants.sidePadding)
        } header: {
            Header("More organizations")
                .padding([.leading, .top, .trailing])
                .padding(.bottom, 6)
        }
    }

    // MARK: - Supporting Views

    private var noFollowedOrgsMessage: some View {
        VolumeMessage(
            image: Image.volume.flyer,
            message: .noFollowingOrganizations,
            largeFont: false,
            fullWidth: true
        )
    }

}

// MARK: - Uncomment below if needed

//#Preview {
//    OrganizationList()
//}
