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
        
        // TODO: Remove dummy data
        @Published var allCategories: [String]? = ["All", "Dance", "Music", "Academic", "Sports"]
        @Published var hasMorePast: Bool = true
        @Published var hasMoreUpcoming: Bool = true
        @Published var pastFlyers: [Flyer]? = FlyerDummyData.pastFlyers
        @Published var selectedCategory: String? = "All"
        @Published var thisWeekFlyers: [Flyer]? = FlyerDummyData.thisWeekFlyers
        @Published var upcomingFlyers: [Flyer]? = FlyerDummyData.upcomingFlyers
        
        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()
        private var userData: UserData?
        
        // MARK: - Property Helpers
        
        var disableScrolling: Bool {
            thisWeekFlyers == .none
        }
                
        func setupEnvironment(networkState: NetworkState, userData: UserData) {
            // TODO: initialize environment properties
        }
        
        // MARK: - Logic Constants
        
        private struct Constants {
            // TODO: Replace values if necessary
            static let thisWeekFlyersLimit: Double = 7
            static let upcomingFlyersLimit: Double = 6
            static let pastFlyersLimit: Double = 10
        }
        
        // MARK: - Public Requests
        
        func fetchContent() async {
            fetchThisWeek()
            fetchCategories()
            
            // TODO: May need to remove this to implement pagination
            fetchUpcoming()
            fetchPast()
        }
        
        func refreshContent() async {
            Network.shared.clearCache()
            queryBag.removeAll()
            
            thisWeekFlyers = nil
            upcomingFlyers = nil
            pastFlyers = nil
            
            hasMorePast = true
            hasMoreUpcoming = true
            
            await fetchContent()
        }
        
        func fetchUpcomingNextPage() {
            // TODO: Fetch next page of flyers under "Upcoming"
        }
        
        func fetchPastNextPage() {
            // TODO: Fetch next set of flyers under "Past Flyers"
        }
        
        // MARK: - Private Requests
        
        private func fetchThisWeek() {
            // TODO: Fetch flyers under "This Week"
        }
        
        private func fetchCategories() {
            // TODO: Fetch flyer categories
        }
        
        private func fetchUpcoming() {
            // TODO: Fetch flyers under "Upcoming"
        }
        
        private func fetchPast() {
            // TODO: Fetch flyers under "Past"
        }
        
        // MARK: - Deeplink
        
        func handleURL(_ url: URL) {
            // TODO: Handle deeplink logic
        }
        
        // MARK: - Helpers
        
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
    }
    
}
