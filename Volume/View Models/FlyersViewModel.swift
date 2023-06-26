//
//  FlyersViewModel.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import Combine
import SwiftUI

extension FlyersView {
    
    @MainActor
    class ViewModel: ObservableObject {
        // MARK: - Properties
        
        @Published var allCategories: [OrganizationType]? = nil
        @Published var dailyFlyers: [Flyer]? = nil
        @Published var hasMorePast: Bool = true
        @Published var hasMoreUpcoming: Bool = true
        @Published var pastFlyers: [Flyer]? = nil
        @Published var searchState: SearchView.SearchState = .searching
        @Published var searchText: String = ""
        @Published var selectedCategory: OrganizationType? = .all
        @Published var thisWeekFlyers: [Flyer]? = nil
        @Published var upcomingFlyers: [Flyer]? = nil
        
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
        
        private struct Constants {
            // TODO: Replace values once pagination is implemented
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
            Network.shared.clearCache()
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
            Network.shared.publisher(for: GetFlyersAfterDateQuery(since: Date().flyerDateTimeString))
                .map { $0.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] flyerFields in
                    var upcoming = [Flyer](flyerFields)
                    if self?.selectedCategory != .all {
                        upcoming = upcoming.filter {
                            $0.organizations.first?.categorySlug == self?.selectedCategory
                        }
                    }
                    self?.upcomingFlyers = self?.sortFlyersByDateAsc(for: upcoming)
                }
                .store(in: &queryBag)
        }
        
        func readFlyer(_ flyer: Flyer) async {
            guard let uuid = userData?.uuid else { return }
            
            Network.shared.publisher(for: IncrementTimesClickedMutation(id: flyer.id, uuid: uuid))
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                    print("Marked flyer \(flyer.id) read")
                } receiveValue: { _ in }
                .store(in: &queryBag)
        }
        
        func fetchUpcomingNextPage() {
            // TODO: Fetch next page of flyers under "Upcoming"
        }
        
        func fetchPastNextPage() {
            // TODO: Fetch next set of flyers under "Past Flyers"
        }
        
        // MARK: - Private Requests
        
        private func fetchDaily() async {
            Network.shared.publisher(for: GetFlyersAfterDateQuery(since: Date().flyerDateTimeString))
                .map { $0.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] flyerFields in
                    var upcomingFlyers = [Flyer](flyerFields)
                    upcomingFlyers = upcomingFlyers.filter { Calendar.current.isDateInToday($0.endDate) }
                    self?.dailyFlyers = self?.sortFlyersByDateAsc(for: upcomingFlyers)
                }
                .store(in: &queryBag)
        }
        
        private func fetchThisWeek() async {
            Network.shared.publisher(for: GetFlyersAfterDateQuery(since: Date().flyerDateTimeString))
                .map { $0.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] flyerFields in
                    var upcomingFlyers = [Flyer](flyerFields)
                    upcomingFlyers = upcomingFlyers.filter {
                        // In this week but not today
                        Calendar.current.isDateInThisWeek($0.endDate) && !Calendar.current.isDateInToday($0.endDate)
                    }
                    self?.thisWeekFlyers = self?.sortFlyersByDateAsc(for: upcomingFlyers)
                }
                .store(in: &queryBag)
        }
        
        private func fetchCategories() async {
            // TODO: Fetch flyer categories once backend implements
            allCategories = [.all, .academic, .art, .awareness, .comedy, .cultural, .dance, .foodDrinks, .greekLife, .music, .socialJustice, .spiritual, .sports]
        }
        
        private func fetchPast() async {
            Network.shared.publisher(
                for: GetFlyersBeforeDateQuery(
                    limit: Constants.pastFlyersLimit,
                    before: Date().flyerDateTimeString)
                )
                .map { $0.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] flyerFields in
                    self?.pastFlyers = [Flyer](flyerFields)
                }
                .store(in: &queryBag)
        }
        
        // MARK: - Deeplink
        
        func handleURL(_ url: URL) {
            // TODO: Handle deeplink logic if needed
        }
        
        // MARK: - Helpers
        
        // TODO: The next two functions are not in use but will by helpful once pagination is implemented
        
        private func loadMoreUpcoming(with newFlyers: [Flyer]) {
            switch upcomingFlyers {
            case .none:
                upcomingFlyers = newFlyers
            case .some(let oldFlyers):
                upcomingFlyers = oldFlyers + newFlyers
            }
            
            // No more upcoming flyers
            if newFlyers.count < Int(Constants.upcomingFlyersLimit) {
                hasMoreUpcoming = false
            }
        }
        
        private func loadMorePast(with newFlyers: [Flyer]) {
            switch pastFlyers {
            case .none:
                pastFlyers = newFlyers
            case .some(let oldFlyers):
                pastFlyers = oldFlyers + newFlyers
            }
        }
        
        /// Calculate the offset for the GraphQL query
        private func offset(for flyers: [Flyer]?) -> Double {
            Double(flyers?.count ?? 0)
        }
        
        /// Returns a list of Flyers sorted by date descending
        private func sortFlyersByDateDesc(for flyers: [Flyer]) -> [Flyer] {
            return flyers.sorted(by: { $0.startDate.compare($1.startDate) == .orderedDescending })
        }
        
        /// Returns a list of Flyers sorted by date ascending
        private func sortFlyersByDateAsc(for flyers: [Flyer]) -> [Flyer] {
            return flyers.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        }

        static func displayShareScreen(for flyer: Flyer) {
            var linkSource: LinkItemSource?

            if let url = flyer.flyerUrl {
                linkSource = LinkItemSource(url: url, flyer: flyer)
            }

            guard let linkSource else { return }

            let shareVC = UIActivityViewController(activityItems: [linkSource], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(shareVC, animated: true)
        }
        
    }
    
}
