//
//  WidgetViewModel.swift
//  Volume
//
//  Created by Vin Bui on 11/17/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import Foundation

final class WidgetViewModel {

    private init() { }

    /// Shared singleton instance
    static let shared = WidgetViewModel()

    // MARK: - Properties

    private let articlesLimit: Double = 4
    private let flyersLimit: Int = 4
    private var queryBag = Set<AnyCancellable>()

    // MARK: - Network Requests

    func fetchTrendingArticles(completion: @escaping ([Article]) -> Void) {
        Network.shared.publisher(for: GetTrendingArticlesQuery(limit: articlesLimit))
            .compactMap { $0.articles.map(\.fragments.articleFields) }
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: GetTrendingArticlesQuery failed in ArticleWidgetProvider: \(error)")
                }
            } receiveValue: { articleFields in
                var articles = [Article](articleFields)
                articles = articles.sorted { $0.date < $1.date }
                completion(articles)
            }
            .store(in: &queryBag)
    }

    func fetchOrganizationNames(completion: @escaping ([Organization]) -> Void) {
        Network.shared.publisher(for: GetAllOrganizationsQuery())
            .map { $0.organizations.map(\.fragments.organizationFields) }
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: GetAllOrganizationNamesQuery failed in WidgetOrganizationQuery: \(error)")
                }
            } receiveValue: { organizationFields in
                var orgs = [Organization](organizationFields)
                orgs = orgs.sorted { $0.name < $1.name }

                completion(orgs)
            }
            .store(in: &queryBag)
    }

    func fetchAllFlyers(forSlug slug: String, completion: @escaping ([Flyer]) -> Void) {
        Network.shared.publisher(for: GetFlyersByOrganizationSlugQuery(slug: slug))
            .map { $0.flyers.map(\.fragments.flyerFields) }
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: GetFlyersByOrganizationSlugQuery failed in FlyerWidgetProvider: \(error)")
                }
            } receiveValue: { [weak self] flyerFields in
                guard let self = self else { return }

                var flyers = [Flyer](flyerFields)

                // Get upcoming flyers - if none, get the most recent
                let upcomingFlyers = flyers.filter { $0.endDate > Date.now }
                if upcomingFlyers.count > 0 {
                    flyers = upcomingFlyers.sorted { $0.startDate > $1.startDate }
                } else {
                    flyers = flyers.sorted { $0.startDate > $1.startDate }
                }

                completion(Array(flyers.prefix(self.flyersLimit)))
            }
            .store(in: &queryBag)
    }

}
