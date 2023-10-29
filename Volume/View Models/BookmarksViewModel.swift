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
        @Published var flyers: [Flyer]?
        @Published var magazines: [Magazine]?
        @Published var selectedTab: FilterContentType = .articles
        @Published private var queryBag = Set<AnyCancellable>()

        private var networkState: NetworkState?
        private var userData: UserData?

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
            ids.publisher
                .map(GetArticleByIdQuery.init)
                .flatMap(Network.shared.publisher)
                .collect()
                .map { $0.compactMap(\.article?.fragments.articleFields) }
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
            Network.shared.publisher(for: GetMagazinesByIDsQuery(ids: ids))
                .map { $0.magazine.map(\.fragments.magazineFields) }
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
            Network.shared.publisher(for: GetFlyersByIDsQuery(ids: ids))
                .map { $0.flyers.map(\.fragments.flyerFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .bookmarks, completion)
                } receiveValue: { [weak self] flyerFields in
                    let flyers = [Flyer](flyerFields)
                    withAnimation(.linear(duration: 0.1)) {
                        self?.flyers = flyers
                    }
                }
                .store(in: &queryBag)
        }

        func readFlyer(_ flyer: Flyer) async {
            Network.shared.publisher(for: IncrementTimesClickedMutation(id: flyer.id))
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                    print("Marked flyer \(flyer.id) read")
                } receiveValue: { _ in
                }
                .store(in: &queryBag)
        }

    }

}
