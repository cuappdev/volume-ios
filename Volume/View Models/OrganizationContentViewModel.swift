//
//  OrganizationContentViewModel.swift
//  Volume
//
//  Created by Vin Bui on 11/17/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension OrganizationContentView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var flyers: [Flyer]?
        @Published var hasMorePages: Bool = true

        private var networkState: NetworkState?
        private var organization: Organization?
        private var queryBag = Set<AnyCancellable>()

        // MARK: - Property Helpers + Constants

        func setupEnvironmentVariables(networkState: NetworkState, organization: Organization) {
            self.networkState = networkState
            self.organization = organization
        }

        private struct Constants {
            static let animationDuration: CGFloat = 0.1
            static let pageSize: Double = 10
        }

        // MARK: - Network Requests

        func fetchPageIfLast(flyer: Flyer) {
            if let flyers, flyers.firstIndex(of: flyer) == flyers.index(flyers.endIndex, offsetBy: -1) {
                Task {
                    await fetchFlyersPage()
                }
            }
        }

        func fetchFlyersPage() async {
            guard let organization else { return }

            Network.shared.publisher(
                for: GetFlyersByOrganizationSlugQuery(
                    limit: Constants.pageSize,
                    slug: organization.slug,
                    offset: Double(flyers?.count ?? 0)
                )
            )
            .map { $0.flyers.map(\.fragments.flyerFields) }
            .sink { [weak self] completion in
                self?.networkState?.handleCompletion(screen: .reads, completion)
            } receiveValue: { [weak self] flyerFields in
                let newFlyers = [Flyer](flyerFields.sorted { $0.endDate > $1.endDate })

                if newFlyers.count < Int(Constants.pageSize) {
                    self?.hasMorePages = false
                }

                withAnimation(.linear(duration: Constants.animationDuration)) {
                    self?.flyers = (self?.flyers ?? []) + newFlyers
                }
            }
            .store(in: &queryBag)
        }

    }

}
