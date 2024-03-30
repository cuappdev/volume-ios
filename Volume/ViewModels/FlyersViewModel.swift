//
//  FlyersViewModel.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension FlyersView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var allCategories: [String]?
        @Published var dailyFlyers: [Flyer]?
        @Published var hasMorePast: Bool = true
        @Published var hasMoreUpcoming: Bool = true
        @Published var pastFlyers: [Flyer]?
        @Published var searchState: SearchView.SearchState = .searching
        @Published var searchText: String = ""
        @Published var selectedCategory: String? = Constants.defaultCategory
        @Published var thisWeekFlyers: [Flyer]?
        @Published var upcomingFlyers: [Flyer]?

        @State private var bookmarkRequestInProgress: Bool = false
        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()
        private var userData: UserData?

        // MARK: - Property Helpers

        func setupEnvironment(networkState: NetworkState, userData: UserData) {
            if self.networkState == nil || self.userData == nil {
                self.networkState = networkState
                self.userData = userData
            }
        }

        // MARK: - Logic Constants

        struct Constants {
            static let defaultCategory: String = "All"
            static let thisWeekFlyersLimit: Double = 7
            static let upcomingFlyersLimit: Double = 6
            static let pastFlyersLimit: Double = 20
        }

        // MARK: - Public Requests

        func fetchContent() async {
            allCategories == nil ? await fetchCategories() : nil
            dailyFlyers == nil ? await fetchDaily() : nil
            thisWeekFlyers == nil ? await fetchThisWeek() : nil
            upcomingFlyers == nil ? await fetchUpcoming() : nil
            pastFlyers == nil ? await fetchPast() : nil
        }

        func refreshContent() async {
            Network.client.clearCache()
            queryBag.removeAll()

            dailyFlyers = nil
            thisWeekFlyers = nil
            upcomingFlyers = nil
            pastFlyers = nil

            hasMorePast = true
            hasMoreUpcoming = true

            await fetchContent()
        }

        func fetchUpcoming() async {
            Network.client.queryPublisher(query: VolumeAPI.GetFlyersAfterDateQuery(since: Date().flyerUTCISOString))
                .compactMap { $0.data?.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] flyerFields in
                    var upcoming = [Flyer](flyerFields)
                    if self?.selectedCategory != Constants.defaultCategory {
                        upcoming = upcoming.filter {
                            $0.organization.categorySlug == self?.selectedCategory
                        }
                    }
                    self?.upcomingFlyers = upcoming.sortByDateAsc
                }
                .store(in: &queryBag)
        }

        func readFlyer(_ flyer: Flyer) async {
            Network.client.mutationPublisher(mutation: VolumeAPI.IncrementTimesClickedMutation(id: flyer.id))
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                    print("Marked flyer \(flyer.id) read")
                } receiveValue: { _ in
                }
                .store(in: &queryBag)
        }

        // MARK: - Private Requests

        private func fetchDaily() async {
            Network.client.queryPublisher(query: VolumeAPI.GetFlyersAfterDateQuery(since: Date().flyerUTCISOString))
                .compactMap { $0.data?.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] flyerFields in
                    var upcomingFlyers = [Flyer](flyerFields)
                    upcomingFlyers = upcomingFlyers.filter { Calendar.current.isDateInToday($0.endDate) }
                    self?.dailyFlyers = upcomingFlyers.sortByDateAsc
                }
                .store(in: &queryBag)
        }

        private func fetchThisWeek() async {
            Network.client.queryPublisher(query: VolumeAPI.GetFlyersAfterDateQuery(since: Date().flyerUTCISOString))
                .compactMap { $0.data?.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] flyerFields in
                    var upcomingFlyers = [Flyer](flyerFields)
                    upcomingFlyers = upcomingFlyers.filter {
                        // In this week but not today
                        Calendar.current.isDateInThisWeek($0.endDate) && !Calendar.current.isDateInToday($0.endDate)
                    }
                    self?.thisWeekFlyers = upcomingFlyers.sortByDateAsc
                }
                .store(in: &queryBag)
        }

        private func fetchCategories() async {
            Network.client.queryPublisher(query: VolumeAPI.GetAllFlyerCategoriesQuery())
                .compactMap { $0.data?.getAllFlyerCategories }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] categories in
                    self?.allCategories = categories
                    self?.allCategories?.insert(Constants.defaultCategory, at: 0)
                }
                .store(in: &queryBag)
        }

        private func fetchPast() async {
            Network.client.queryPublisher(
                query: VolumeAPI.GetFlyersBeforeDateQuery(
                    limit: GraphQLNullable<Double>(floatLiteral: Constants.pastFlyersLimit),
                    before: Date().flyerUTCISOString
                )
            )
            .compactMap { $0.data?.flyers.map(\.fragments.flyerFields) }
            .sink { [weak self] completion in
                self?.networkState?.handleCompletion(screen: .flyers, completion)
            } receiveValue: { [weak self] flyerFields in
                self?.pastFlyers = [Flyer](flyerFields)
            }
            .store(in: &queryBag)
        }

        // MARK: - Helpers

        /// Calculate the offset for the GraphQL query
        private func offset(for flyers: [Flyer]?) -> Double {
            Double(flyers?.count ?? 0)
        }

        static func displayShareScreen(for flyer: Flyer) {
            var linkSource: LinkItemSource?

            if let url = flyer.flyerUrl {
                linkSource = LinkItemSource(url: url, flyer: flyer)
            }

            guard let linkSource else { return }

            let shareVC = UIActivityViewController(
                activityItems: [linkSource],
                applicationActivities: nil
            )
            UIApplication.shared.windows.first?.rootViewController?.present(shareVC, animated: true)
        }

    }

}
