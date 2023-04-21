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
            allCategories == nil ? fetchCategories() : nil
            thisWeekFlyers == nil ? fetchThisWeek() : nil
            upcomingFlyers == nil ? await fetchUpcoming() : nil
            pastFlyers == nil ? fetchPast() : nil
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
            guard let url = URL(string: "\(Secrets.cboardEndpoint)/flyers/upcoming/") else { return }
            
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
                .decode(type: [Flyer].self, decoder: JSONDecoder.flyersDecoder)
                .sink { completion in
                    print("Fetching upcoming flyers: \(completion)")
                } receiveValue: { [weak self] flyers in
                    let sortedFlyers = self?.sortFlyersByDateAsc(for: flyers)
                                        
                    if self?.selectedCategory == .all {
                        self?.upcomingFlyers = sortedFlyers
                    } else {
                        self?.upcomingFlyers = sortedFlyers?.filter { $0.organizations[0].type == self?.selectedCategory }
                    }
                }
                .store(in: &queryBag)
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
            guard let url = URL(string: "\(Secrets.cboardEndpoint)/flyers/weekly/") else { return }
            
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
                .decode(type: [Flyer].self, decoder: JSONDecoder.flyersDecoder)
                .sink { completion in
                    print("Fetching weekly flyers: \(completion)")
                } receiveValue: { [weak self] flyers in
                    let sortedFlyers = self?.sortFlyersByDateAsc(for: flyers)
                    self?.thisWeekFlyers = sortedFlyers
                }
                .store(in: &queryBag)
        }
        
        private func fetchCategories() {
            // TODO: Fetch flyer categories once backend implements
            allCategories = [.all, .academic, .art, .awareness, .comedy, .cultural, .dance, .foodDrinks, .greekLife, .music, .socialJustice, .spiritual, .sports]
        }
        
        private func fetchPast() {
            // TODO: Fetch flyers under "Past"
            guard let url = URL(string: "\(Secrets.cboardEndpoint)/flyers/past/") else { return }
            
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
                .decode(type: [Flyer].self, decoder: JSONDecoder.flyersDecoder)
                .sink { completion in
                    print("Fetching past flyers: \(completion)")
                } receiveValue: { [weak self] flyers in
                    let sortedFlyers = self?.sortFlyersByDateDesc(for: flyers)
                    self?.pastFlyers = sortedFlyers
                }
                .store(in: &queryBag)
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
