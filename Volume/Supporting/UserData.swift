//
//  FollowingData.swift
//  Volume
//
//  Created by Daniel Vebman on 12/6/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class UserData: ObservableObject {

    static let shared = UserData()

    private let articleShoutoutsKey = "articleShoutoutsCounter"
    private let articlesKey = "savedArticleIds"
    private let fcmTokenKey = "fcmToken"
    private let flyersKey = "savedFlyersIds"
    private let isFirstLaunchKey = "isFirstLaunch"
    private let magazineShoutoutsKey = "magazineShoutoutsCounter"
    private let magazinesKey = "savedMagazineIds"
    private let organizationsKey = "savedOrganizationSlugs"
    private let publicationsKey = "savedPublicationSlugs"
    private let recentSearchesKey = "recentSearchQueries"
    private let userUUIDKey = "userUUID"
    private let weeklyDebriefKey = "weeklyDebrief"

    /// This cache maps `Article` and `Publication`  slugs to shout outs. Its purpose is to allow the UI to
    /// display incremented shoutouts without refetching the model from the server. Users of the cache should
    /// display the max of the stored value if any and the model's `shoutouts`. This way, there is no need to
    /// wipe the cache.
    @Published var shoutoutsCache: [String: Int] = [:] {
        willSet {
            self.objectWillChange.send()
        }
    }

    @Published private(set) var savedArticleIDs: [String] = [] {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: articlesKey)
            self.objectWillChange.send()
        }
    }

    @Published private(set) var followedPublicationSlugs: [String] = [] {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: publicationsKey)
            self.objectWillChange.send()
        }
    }

    @Published private(set) var followedOrganizationSlugs: [String] = [] {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: organizationsKey)
            self.objectWillChange.send()
        }
    }

    @Published private var articleShoutoutsCounter: [String: Int] = [:] {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: articleShoutoutsKey)
            self.objectWillChange.send()
        }
    }

    @Published var magazineShoutoutsCache: [String: Int] = [:] {
        willSet {
            self.objectWillChange.send()
        }
    }

    @Published private(set) var savedMagazineIDs: [String] = [] {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: magazinesKey)
            self.objectWillChange.send()
        }
    }

    @Published private var magazineShoutoutsCounter: [String: Int] = [:] {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: magazineShoutoutsKey)
            self.objectWillChange.send()
        }
    }

    @Published var recentSearchQueries: [String] = [] {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: recentSearchesKey)
            self.objectWillChange.send()
        }
    }

    @Published private(set) var savedFlyerIDs: [String] = [] {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: flyersKey)
            self.objectWillChange.send()
        }
    }

    var uuid: String? {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: userUUIDKey)
        }
    }

    var weeklyDebrief: WeeklyDebrief? {
        willSet {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: weeklyDebriefKey)
            } else {
                print("Error: failed to encode WeeklyDebrief object")
            }
        }
    }

    var fcmToken: String? {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: fcmTokenKey)
        }
    }

    private var cancellables: [Mutation: AnyCancellable?] = [:]

    private init() {
        if let ids = UserDefaults.standard.object(forKey: articlesKey) as? [String] {
            savedArticleIDs = ids
        }

        if let ids = UserDefaults.standard.object(forKey: magazinesKey) as? [String] {
            savedMagazineIDs = ids
        }

        if let ids = UserDefaults.standard.object(forKey: flyersKey) as? [String] {
            savedFlyerIDs = ids
        }

        if let slugs = UserDefaults.standard.object(forKey: publicationsKey) as? [String] {
            followedPublicationSlugs = slugs
        }

        if let slugs = UserDefaults.standard.object(forKey: organizationsKey) as? [String] {
            followedOrganizationSlugs = slugs
        }

        if let shoutoutsCounter = UserDefaults.standard.object(forKey: articleShoutoutsKey) as? [String: Int] {
            articleShoutoutsCounter = shoutoutsCounter
        }

        if let shoutoutsCounter = UserDefaults.standard.object(forKey: magazineShoutoutsKey) as? [String: Int] {
            magazineShoutoutsCounter = shoutoutsCounter
        }

        if let queries = UserDefaults.standard.object(forKey: recentSearchesKey) as? [String] {
            recentSearchQueries = queries
        }

        if let debriefData = UserDefaults.standard.object(forKey: weeklyDebriefKey) as? Data,
           let debrief = try? JSONDecoder().decode(WeeklyDebrief.self, from: debriefData) {
            weeklyDebrief = debrief
        }

        if let fcmToken = UserDefaults.standard.object(forKey: fcmTokenKey) as? String {
            self.fcmToken = fcmToken
        }

        if let uuid = UserDefaults.standard.object(forKey: userUUIDKey) as? String {
#if DEBUG
            print("Initializing UserData with UUID: \(uuid)")
#endif
            self.uuid = uuid
        }
    }

    func isArticleSaved(_ article: Article) -> Bool {
        savedArticleIDs.contains(article.id)
    }

    func isMagazineSaved(_ magazine: Magazine) -> Bool {
        savedMagazineIDs.contains(magazine.id)
    }

    func isFlyerSaved(_ flyer: Flyer) -> Bool {
        savedFlyerIDs.contains(flyer.id)
    }

    func isPublicationFollowed(_ publication: Publication) -> Bool {
        followedPublicationSlugs.contains(publication.slug)
    }

    func isOrganizationFollowed(_ organization: Organization) -> Bool {
        followedOrganizationSlugs.contains(organization.slug)
    }

    func toggleArticleSaved(_ article: Article, _ bookmarkRequestInProgress: Binding<Bool>) {
        Task {
            await set(
                article: article,
                isSaved: !isArticleSaved(article),
                bookmarkRequestInProgress: bookmarkRequestInProgress
            )
        }
    }

    func toggleMagazineSaved(_ magazine: Magazine, _ bookmarkRequestInProgress: Binding<Bool>) {
        Task {
            await set(
                magazine: magazine,
                isSaved: !isMagazineSaved(magazine),
                bookmarkRequestInProgress: bookmarkRequestInProgress
            )
        }
    }

    func toggleFlyerSaved(_ flyer: Flyer, _ bookmarkRequestInProgress: Binding<Bool>) {
        Task {
            await set(flyer: flyer, isSaved: !isFlyerSaved(flyer), bookmarkRequestInProgress: bookmarkRequestInProgress)
        }
    }

    func togglePublicationFollowed(_ publication: Publication, _ followRequestInProgress: Binding<Bool>) {
        Task {
            await set(
                publication: publication,
                isFollowed: !isPublicationFollowed(publication),
                followRequestInProgress: followRequestInProgress
            )
        }
    }

    func toggleOrganizationFollowed(_ organization: Organization, _ followRequestInProgress: Binding<Bool>) {
        Task {
            await set(
                organization: organization,
                isFollowed: !isOrganizationFollowed(organization),
                followRequestInProgress: followRequestInProgress
            )
        }
    }

    func canIncrementShoutouts(_ article: Article) -> Bool {
        articleShoutoutsCounter[article.id, default: 0] < 5
    }

    func incrementShoutoutsCounter(_ article: Article) {
        articleShoutoutsCounter[article.id, default: 0] += 1
    }

    func canIncrementMagazineShoutouts(_ magazine: Magazine) -> Bool {
        magazineShoutoutsCounter[magazine.id, default: 0] < 5
    }

    func incrementMagazineShoutoutsCounter(_ magazine: Magazine) {
        magazineShoutoutsCounter[magazine.id, default: 0] += 1
    }

    func addRecentSearchQueries(_ query: String) {
        let maxSearches: Int = 20

        recentSearchQueries = recentSearchQueries.filter { $0 != query }
        recentSearchQueries.insert(query, at: 0)
        if recentSearchQueries.count > maxSearches { recentSearchQueries.removeLast() }
    }

    func removeRecentSearchQueries(_ query: String) {
        recentSearchQueries = recentSearchQueries.filter { $0 != query }
    }

    func set(article: Article, isSaved: Bool, bookmarkRequestInProgress: Binding<Bool>) async {
        @Binding var requestInProgress: Bool
        _requestInProgress = bookmarkRequestInProgress

        guard let uuid = uuid else {
#if DEBUG
            print("Error: received nil for UUID in set(article:isSaved)")
#endif
            requestInProgress = false
            return
        }

        if isSaved {
            cancellables[.bookmarkArticle(article)] = Network.shared.publisher(for: BookmarkArticleMutation(uuid: uuid))
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error: BookmarkArticleMutation failed on UserData: \(error.localizedDescription)")
                    }
                    requestInProgress = false
                } receiveValue: { _ in
                    if !self.savedArticleIDs.contains(article.id) {
                        self.savedArticleIDs.insert(article.id, at: 0)
                    }
                }
        } else {
            requestInProgress = false
            self.savedArticleIDs.removeAll(where: { $0 == article.id })
        }
    }

    func set(magazine: Magazine, isSaved: Bool, bookmarkRequestInProgress: Binding<Bool>) async {
        @Binding var requestInProgress: Bool
        _requestInProgress = bookmarkRequestInProgress

        guard let uuid = uuid else {
            #if DEBUG
            print("Error: received nil for UUID in set(magazine :isSaved)")
            #endif
            requestInProgress = false
            return
        }

        if isSaved {
            cancellables[.bookmarkMagazine(magazine)] = Network.shared.publisher(
                for: BookmarkMagazineMutation(uuid: uuid)
            )
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: BookmarkMagazineMutation failed on UserData: \(error.localizedDescription)")
                }
                requestInProgress = false
            } receiveValue: { _ in
                if !self.savedMagazineIDs.contains(magazine.id) {
                    self.savedMagazineIDs.insert(magazine.id, at: 0)
                }
            }
        } else {
            requestInProgress = false
            self.savedMagazineIDs.removeAll(where: { $0 == magazine.id })
        }
    }

    func set(flyer: Flyer, isSaved: Bool, bookmarkRequestInProgress: Binding<Bool>) async {
        @Binding var requestInProgress: Bool
        _requestInProgress = bookmarkRequestInProgress

        guard let uuid = uuid else {
#if DEBUG
            print("Error: received nil for UUID in set(flyer :isSaved)")
#endif
            requestInProgress = false
            return
        }

        if isSaved {
            cancellables[.bookmarkFlyer(flyer)] = Network.shared.publisher(for: BookmarkFlyerMutation(uuid: uuid))
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error: BookmarkFlyerMutation failed on UserData: \(error.localizedDescription)")
                    }
                    requestInProgress = false
                } receiveValue: { _ in
                    if !self.savedFlyerIDs.contains(flyer.id) {
                        self.savedFlyerIDs.insert(flyer.id, at: 0)
                    }
                }
        } else {
            requestInProgress = false
            self.savedFlyerIDs.removeAll(where: { $0 == flyer.id })
        }
    }

    func set(publication: Publication, isFollowed: Bool, followRequestInProgress: Binding<Bool>) async {
        @Binding var requestInProgress: Bool
        _requestInProgress = followRequestInProgress

        guard let uuid = uuid else {
            // User has not finished onboarding
            if isFollowed {
                if !self.followedPublicationSlugs.contains(publication.slug) {
                    self.followedPublicationSlugs.insert(publication.slug, at: 0)
                }
            } else {
                self.followedPublicationSlugs.removeAll(where: { $0 == publication.slug })
            }
            requestInProgress = false
            return
        }

        if isFollowed {
            let followMutation = FollowPublicationMutation(slug: publication.slug, uuid: uuid)
            cancellables[.followPublication(publication)] = Network.shared.publisher(for: followMutation)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error: FollowPublicationMutation failed on UserData: \(error.localizedDescription)")
                    }
                    requestInProgress = false
                } receiveValue: { _ in
                    if !self.followedPublicationSlugs.contains(publication.slug) {
                        self.followedPublicationSlugs.insert(publication.slug, at: 0)
                    }
                }

        } else {
            let unfollowMutation = UnfollowPublicationMutation(slug: publication.slug, uuid: uuid)
            cancellables[.unfollowPublication(publication)] = Network.shared.publisher(for: unfollowMutation)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error: UnfollowPublicationMutation failed on UserData: \(error.localizedDescription)")
                    }
                    requestInProgress = false
                } receiveValue: { _ in
                    self.followedPublicationSlugs.removeAll(where: { $0 == publication.slug })
                }
        }
    }

    func set(organization: Organization, isFollowed: Bool, followRequestInProgress: Binding<Bool>) async {
        @Binding var requestInProgress: Bool
        _requestInProgress = followRequestInProgress

        guard let uuid = uuid else {
            // User has not finished onboarding
            if isFollowed {
                if !self.followedOrganizationSlugs.contains(organization.slug) {
                    self.followedOrganizationSlugs.insert(organization.slug, at: 0)
                }
            } else {
                self.followedOrganizationSlugs.removeAll(where: { $0 == organization.slug })
            }
            requestInProgress = false
            return
        }

        if isFollowed {
            let followMutation = FollowOrganizationMutation(slug: organization.slug, uuid: uuid)
            cancellables[.followOrganization(organization)] = Network.shared.publisher(for: followMutation)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error: FollowOrganizationMutation failed on UserData: \(error.localizedDescription)")
                    }
                    requestInProgress = false
                } receiveValue: { _ in
                    if !self.followedOrganizationSlugs.contains(organization.slug) {
                        self.followedOrganizationSlugs.insert(organization.slug, at: 0)
                    }
                }

        } else {
            let unfollowMutation = UnfollowOrganizationMutation(slug: organization.slug, uuid: uuid)
            cancellables[.unfollowOrganization(organization)] = Network.shared.publisher(for: unfollowMutation)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error: UnfollowOrganizationMutation failed on UserData: \(error.localizedDescription)")
                    }
                    requestInProgress = false
                } receiveValue: { _ in
                    self.followedOrganizationSlugs.removeAll(where: { $0 == organization.slug })
                }
        }
    }

}

extension UserData {

    private enum Mutation: Hashable {
        case followPublication(Publication)
        case unfollowPublication(Publication)
        case followOrganization(Organization)
        case unfollowOrganization(Organization)
        case bookmarkArticle(Article)
        case bookmarkMagazine(Magazine)
        case bookmarkFlyer(Flyer)
    }

}
