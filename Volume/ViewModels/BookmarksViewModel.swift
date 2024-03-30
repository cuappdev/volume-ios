//
//  BookmarksViewModel.swift
//  Volume
//
//  Created by Vin Bui on 4/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension BookmarksView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var articles: [Article]?
        @Published var magazines: [Magazine]?
        @Published var pastCategories: [String] = []
        @Published var pastFlyers: [Flyer]?
        @Published var selectedPastCategory: String? = Constants.defaultCategory
        @Published var selectedTab: FilterContentType = .articles
        @Published var selectedUpcomingCategory: String? = Constants.defaultCategory
        @Published var upcomingCategories: [String] = []
        @Published var upcomingFlyers: [Flyer]?

        private var allFlyers: [Flyer] = []
        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()
        private var userData: UserData?

        // MARK: - Logic Constants

        struct Constants {
            static let defaultCategory: String = "All"
        }

        // MARK: - Property Helpers

        func setupEnvironmentVariables(networkState: NetworkState, userData: UserData) {
            self.networkState = networkState
            self.userData = userData
        }

        var hasSavedArticles: Bool {
            guard let userData else {
                return false
            }

            return !userData.savedArticleIDs.isEmpty
        }

        var hasSavedMagazines: Bool {
            guard let userData else {
                return false
            }

            return !userData.savedMagazineIDs.isEmpty
        }

        var hasSavedFlyers: Bool {
            guard let userData else {
                return false
            }

            return !userData.savedFlyerIDs.isEmpty
        }

        // MARK: - Network Requests

        func fetchContent() async {
            await fetchArticles(ids: userData?.savedArticleIDs ?? [])
            await fetchMagazines(ids: userData?.savedMagazineIDs ?? [])
            await fetchFlyers(ids: userData?.savedFlyerIDs ?? [])
        }

        func fetchArticles(ids: [String]) async {
            Network.client.queryPublisher(query: VolumeAPI.GetArticlesByIDsQuery(ids: ids))
                .compactMap { $0.data?.articles.map(\.fragments.articleFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .bookmarks, completion)
                } receiveValue: { [weak self] articleFields in
                    let savedArticleIDs = self?.userData?.savedArticleIDs
                    let articles = [Article](articleFields).sorted {
                        guard let index1 = savedArticleIDs?.firstIndex(of: $0.id),
                              let index2 = savedArticleIDs?.firstIndex(of: $1.id) else {
                            return true
                        }
                        return index1 < index2
                    }
                    withAnimation(.linear(duration: 0.1)) {
                        self?.articles = articles
                    }
                }
                .store(in: &queryBag)
        }

        func fetchMagazines(ids: [String]) async {
            Network.client.queryPublisher(query: VolumeAPI.GetMagazinesByIDsQuery(ids: ids))
                .compactMap { $0.data?.magazines.map(\.fragments.magazineFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .bookmarks, completion)
                } receiveValue: { [weak self] magazineFields in
                    Task {
                        let magazines = await [Magazine](magazineFields)
                        withAnimation(.linear(duration: 0.1)) {
                            self?.magazines = magazines
                        }
                    }
                }
                .store(in: &queryBag)
        }

        func fetchFlyers(ids: [String]) async {
            Network.client.queryPublisher(query: VolumeAPI.GetFlyersByIDsQuery(ids: ids))
                .compactMap { $0.data?.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .bookmarks, completion)
                } receiveValue: { [weak self] flyerFields in
                    let flyers = [Flyer](flyerFields)
                    let upcomingFlyers = flyers.filter { $0.endDate > Date() }
                    let pastFlyers = flyers.filter { $0.endDate < Date() }

                    var upcomingCategories = Array(Set(upcomingFlyers.map(\.categorySlug)))
                    var pastCategories = Array(Set(pastFlyers.map(\.categorySlug)))
                    upcomingCategories.insert(Constants.defaultCategory, at: 0)
                    pastCategories.insert(Constants.defaultCategory, at: 0)

                    self?.upcomingCategories = upcomingCategories
                    self?.pastCategories = pastCategories
                    self?.allFlyers = flyers

                    withAnimation(.linear(duration: 0.1)) {
                        self?.upcomingFlyers = upcomingFlyers
                        self?.pastFlyers = pastFlyers
                    }
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

        // MARK: - Helpers

        func filterUpcoming() {
            if selectedUpcomingCategory == Constants.defaultCategory {
                upcomingFlyers = allFlyers.filter { $0.endDate > Date() }
            } else {
                upcomingFlyers = allFlyers.filter {
                    $0.endDate > Date() && $0.categorySlug == selectedUpcomingCategory
                }
            }
        }

        func filterPast() {
            if selectedPastCategory == Constants.defaultCategory {
                pastFlyers = allFlyers.filter { $0.endDate < Date() }
            } else {
                pastFlyers = allFlyers.filter {
                    $0.endDate < Date() && $0.categorySlug == selectedPastCategory
                }
            }
        }

    }

}
