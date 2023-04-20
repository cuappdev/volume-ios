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
        
        @Published var allCategories: [OrganizationType]? = nil
        @Published var allFlyers: [Flyer]? = nil
        @Published var hasMorePast: Bool = true
        @Published var hasMoreUpcoming: Bool = true
        @Published var pastFlyers: [Flyer]? = nil
        @Published var selectedCategory: OrganizationType? = .all
        @Published var thisWeekFlyers: [Flyer]? = nil
        @Published var upcomingFlyers: [Flyer]? = nil
        
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
            // TODO: Replace values if necessary
            static let thisWeekFlyersLimit: Double = 7
            static let upcomingFlyersLimit: Double = 6
            static let pastFlyersLimit: Double = 10
        }
        
        // MARK: - Public Requests
        
        func fetchContent() async {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d yy h:mm a"
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            guard let url = URL(string: "\(Secrets.cboardEndpoint)/flyers/") else { return }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap { data, response in
                    guard let response = response as? HTTPURLResponse,
                          response.statusCode >= 200 && response.statusCode < 300 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: [Flyer].self, decoder: decoder)
                .sink { completion in
                    print("COMPLETION: \(completion)")
                } receiveValue: { [weak self] flyers in
                    self?.allFlyers = flyers
                    
                    self?.fetchThisWeek()
                    self?.fetchCategories()
                    
                    // TODO: May need to remove this to implement pagination
                    Task {
                        await self?.fetchUpcoming()
                    }
                    self?.fetchPast()
                }
                .store(in: &queryBag)
        }
        
        func refreshContent() async {
            Network.shared.clearCache()
            queryBag.removeAll()
            
            allFlyers = nil
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
                upcomingFlyers = allFlyers?.filter { $0.startDate > Date() }
            } else {
                upcomingFlyers = allFlyers?.filter { $0.startDate > Date() && $0.organizations[0].type == selectedCategory }
            }
            upcomingFlyers = sortFlyersByDateAsc(for: upcomingFlyers ?? [])
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
            thisWeekFlyers = allFlyers?.filter { $0.startDate.isBetween(Date(), and: Date(timeIntervalSinceNow: 604800)) }
            thisWeekFlyers = sortFlyersByDateAsc(for: thisWeekFlyers ?? [])
        }
        
        private func fetchCategories() {
            // TODO: Fetch flyer categories once backend implements
            allCategories = [.all, .academic, .art, .awareness, .comedy, .cultural, .dance, .foodDrinks, .greekLife, .music, .socialJustice, .spiritual, .sports]
        }
        
        private func fetchPast() {
            // TODO: Fetch flyers under "Past"
            
            // Get flyers that is earlier than now
            pastFlyers = allFlyers?.filter { $0.startDate < Date() }
            pastFlyers = sortFlyersByDateDesc(for: pastFlyers ?? [])
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
        
        /// Returns a list of Flyers sorted by date descending
        private func sortFlyersByDateDesc(for flyers: [Flyer]) -> [Flyer] {
            return flyers.sorted(by: { $0.startDate.compare($1.startDate) == .orderedDescending })
        }
        
        /// Returns a list of Flyers sorted by date ascending
        private func sortFlyersByDateAsc(for flyers: [Flyer]) -> [Flyer] {
            return flyers.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        }
    }
    
}
