//
//  OrgsAdminViewModel.swift
//  Volume
//
//  Created by Vin Bui on 11/4/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension OrgsAdminView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var displayedFlyers: [Flyer]?
        @Published var selectedTab: FilterFlyerType = .upcoming

        private var pastFlyers: [Flyer]?
        private var upcomingFlyers: [Flyer]?

        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()

        // MARK: - Property Helpers

        func setupEnvironment(networkState: NetworkState) {
            if self.networkState == nil {
                self.networkState = networkState
            }
        }

        // MARK: - Public Requests

        func fetchContent(for organization: Organization) async {
            Network.shared.publisher(for: GetFlyersByOrganizationSlugQuery(slug: organization.slug))
                .map { $0.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .bookmarks, completion)
                } receiveValue: { [weak self] flyerFields in
                    guard let self = self else { return }

                    let fetchedFlyers = [Flyer](flyerFields)
                    pastFlyers = fetchedFlyers.filter { $0.startDate < Date() }.sortByDateDesc
                    upcomingFlyers = fetchedFlyers.filter { $0.startDate > Date() }.sortByDateAsc

                    filterContentSelection()
                }
                .store(in: &queryBag)
        }

        func refreshContent(for organization: Organization) async {
            Network.shared.clearCache()
            queryBag.removeAll()

            displayedFlyers = nil

            await fetchContent(for: organization)
        }

        func filterContentSelection() {
            switch selectedTab {
            case .past:
                displayedFlyers = pastFlyers
            case .upcoming:
                displayedFlyers = upcomingFlyers
            }
        }

    }

}
