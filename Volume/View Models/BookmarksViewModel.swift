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
        
        // TODO: Property for flyers
        @Published var articles: [Article]? = nil
        @Published var magazines: [Magazine]? = nil
        @Published var selectedTab: FilterContentType = .flyers
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
        
        // TODO: hasSavedFlyers
        
        // MARK: - Network Requests
        
        func fetchContent() {
            fetchArticles(ids: userData?.savedArticleIDs ?? [])
            fetchMagazines(ids: userData?.savedMagazineIDs ?? [])
        }

        func fetchArticles(ids: [String]) {
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

        func fetchMagazines(ids: [String]) {
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
        
        // TODO: fetchFlyers
    }
    
}

