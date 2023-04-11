//
//  TrendingViewModel.swift
//  Volume
//
//  Created by Vin Bui on 4/5/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension TrendingView {
    
    @MainActor
    class ViewModel: ObservableObject {
        // MARK: - Properties
                
        @Published var flyers: [Flyer]?
        @Published var mainArticle: Article?
        @Published var magazines: [Magazine]?
        @Published var subArticles: [Article]?
        
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
            // TODO: May need to change depending on backend queries
            static let flyersLimit: Double = 2
            static let mainArticleLimit: Double = 1
            static let magazinesLimit: Double = 4
            static let subArticlesLimit: Double = 3
        }
        
        // MARK: - Public Requests
        
        func fetchContent() async {
            fetchMainArticle()
            fetchSubArticles()
        }
        
        func refreshContent(_ done: @escaping () -> Void = { } ) {
            Network.shared.clearCache()
            queryBag.removeAll()
            
            flyers = nil
            mainArticle = nil
            magazines = nil
            subArticles = nil
            
            Task {
                await fetchContent()
                done()
            }
        }
        
        func fetchFlyers() async {
            // TODO: Change query once backend implements trending
            
            // Fetch two random flyers from dummy data
            let upcomingFlyers = FlyerDummyData.flyers.filter { $0.date.start > Date() }
            flyers = upcomingFlyers[randomPick: 2]
        }
        
        func fetchMagazines() async {
            // TODO: Change query once backend implements trending
            Network.shared.publisher(
                for: GetAllMagazinesQuery(
                    limit: Constants.magazinesLimit,
                    offset: 0
                ))
                .map { $0.magazines.map(\.fragments.magazineFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .trending, completion)
                } receiveValue: { [weak self] magazineFields in
                    Task {
                        self?.magazines = await [Magazine](magazineFields)
                    }
                }
                .store(in: &queryBag)
        }
        
        // MARK: - Private Requests
        
        private func fetchMainArticle() {
            // TODO: Change query once backend implements trending
            Network.shared.publisher(
                for: GetArticlesByPublicationSlugQuery(
                    slug: "guac",
                    limit: Constants.mainArticleLimit,
                    offset: Double.random(in: 0..<20)   // Just for fun :) will replace
                ))
                .map { $0.articles.map(\.fragments.articleFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .trending, completion)
                } receiveValue: { [weak self] articleFields in
                    let articles = [Article] (articleFields)
                    self?.mainArticle = articles[0]
                }
                .store(in: &queryBag)
        }
        
        private func fetchSubArticles() {
            // TODO: Change query once backend implements trending
            Network.shared.publisher(
                for: GetTrendingArticlesQuery(
                    limit: Constants.subArticlesLimit
                ))
                .map { $0.articles.map(\.fragments.articleFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .trending, completion)
                } receiveValue: { [weak self] articleFields in
                    self?.subArticles = [Article] (articleFields)
                }
                .store(in: &queryBag)
        }
        
    }
    
}
