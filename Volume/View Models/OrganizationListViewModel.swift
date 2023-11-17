//
//  OrganizationListViewModel.swift
//  Volume
//
//  Created by Vin Bui on 11/16/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension OrganizationList {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var followedOrgs: [Organization]?
        @Published var unfollowedOrgs: [Organization]?

        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()
        private var userData: UserData?

        // MARK: - Property Helpers

        func setupEnvironmentVariables(networkState: NetworkState, userData: UserData) {
            self.networkState = networkState
            self.userData = userData
        }

        var hasFollowedOrganizations: Bool {
            guard let userData else { return false }

            return !userData.followedOrganizationSlugs.isEmpty
        }

        // MARK: - Network Requests

        func refreshContent() {
            Network.shared.clearCache()
            queryBag.removeAll()

            followedOrgs = nil
            unfollowedOrgs = nil

            Task {
                await fetchAllOrganizations()
            }
        }

        func fetchAllOrganizations() async {
            guard let userData else { return }

            Network.shared.publisher(for: GetAllOrganizationsQuery())
                .map { $0.organizations.map(\.fragments.organizationFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] organizationFields in
                    let orgs = [Organization](organizationFields)
                    self?.followedOrgs = orgs.filter { userData.isOrganizationFollowed($0) }
                    self?.unfollowedOrgs = orgs.filter { !userData.isOrganizationFollowed($0) }
                }
                .store(in: &queryBag)
        }

    }

}
