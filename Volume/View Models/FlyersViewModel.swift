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
        @Published var allCategories: [Organization.ContentType]? = nil
        @Published var hasMorePast: Bool = true
        @Published var hasMoreUpcoming: Bool = true
        @Published var pastFlyers: [Flyer]? = nil
        @Published var selectedCategory: Organization.ContentType? = .all
        @Published var thisWeekFlyers: [Flyer]? = nil
        @Published var upcomingFlyers: [Flyer]? = nil
        
        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()
        private var userData: UserData?
        
        // MARK: - Property Helpers
        
        var disableScrolling: Bool {
            thisWeekFlyers == .none
        }
                
        func setupEnvironment(networkState: NetworkState, userData: UserData) {
            if self.networkState == nil || self.userData == nil {
                self.networkState = networkState
                self.userData = userData
            }
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
            await fetchUpcoming()
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
        
        func fetchUpcoming() async {
            // TODO: Fetch flyers under "Upcoming"
            
            // Get flyers that is later than now and matches the current category
            if selectedCategory == .all {
                upcomingFlyers = FlyerDummyData.flyers.filter { $0.date.start > Date() }
            } else {
                upcomingFlyers = FlyerDummyData.flyers.filter { $0.date.start > Date() && $0.organizations[0].contentType == selectedCategory }
            }
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
            
            // Get flyers that are between now and 7 days from now
            thisWeekFlyers = FlyerDummyData.flyers.filter { $0.date.start.isBetween(Date(), and: Date(timeIntervalSinceNow: 604800)) }
        }
        
        private func fetchCategories() {
            // TODO: Fetch flyer categories once backend implements
            allCategories = [.all, .academic, .awareness, .comedy, .cultural, .dance, .music]
        }
        
        private func fetchPast() {
            // TODO: Fetch flyers under "Past"
            
            // Get flyers that is earlier than now
            pastFlyers = FlyerDummyData.flyers.filter { $0.date.start < Date() }
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
