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

class UserData: ObservableObject {

    static let shared = UserData()
    
    private let articleShoutoutsKey = "articleShoutoutsCounter"
    private let articlesKey = "savedArticleIds"
    private let fcmTokenKey = "fcmToken"
    private let isFirstLaunchKey = "isFirstLaunch"
    private let publicationsKey = "savedPublicationSlugs"
    private let userUUIDKey = "userUUID"
    private let weeklyDebriefKey = "weeklyDebrief"
    
    /// This cache maps `Article` and `Publication`  slugs to shout outs. Its purpose is to allow the UI to
    /// display incremented shoutouts without refetching the model from the server. Users of the cache should
    /// display the max of the stored value if any and the model's `shoutouts`. This way, there is no need to
    /// wipe the cache.
    @Published var shoutoutsCache: [String: Int] = [:] {
        willSet {
            objectWillChange.send()
        }
    }

    @Published private(set) var savedArticleIDs: [String] = [] {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: articlesKey)
            objectWillChange.send()
        }
    }

    @Published private(set) var followedPublicationSlugs: [String] = [] {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: publicationsKey)
            objectWillChange.send()
        }
    }

    @Published private var articleShoutoutsCounter: [String: Int] = [:] {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: articleShoutoutsKey)
            objectWillChange.send()
        }
    }
    
    var uuid: String? = nil {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: userUUIDKey)
        }
    }
    
    var weeklyDebrief: WeeklyDebrief? = nil {
        willSet {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: weeklyDebriefKey)
            } else {
                print("Error: failed to encode WeeklyDebrief object")
            }
        }
    }
    
    var fcmToken: String? = nil {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: fcmTokenKey)
        }
    }
    
    private var cancellables: [Mutation : AnyCancellable?] = [:]

    private init() {
        if let ids = UserDefaults.standard.object(forKey: articlesKey) as? [String] {
            savedArticleIDs = ids
        }

        if let slugs = UserDefaults.standard.object(forKey: publicationsKey) as? [String] {
            followedPublicationSlugs = slugs
        }

        if let shoutoutsCounter = UserDefaults.standard.object(forKey: articleShoutoutsKey) as? [String: Int] {
            articleShoutoutsCounter = shoutoutsCounter
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

    func isPublicationFollowed(_ publication: Publication) -> Bool {
        followedPublicationSlugs.contains(publication.slug)
    }

    func toggleArticleSaved(_ article: Article, _ bookmarkRequestInProgress: Binding<Bool>) {
        set(article: article, isSaved: !isArticleSaved(article), bookmarkRequestInProgress: bookmarkRequestInProgress)
    }

    func togglePublicationFollowed(_ publication: Publication, _ followRequestInProgress: Binding<Bool>) {
        set(publication: publication, isFollowed: !isPublicationFollowed(publication), followRequestInProgress: followRequestInProgress)
    }

    func canIncrementShoutouts(_ article: Article) -> Bool {
        articleShoutoutsCounter[article.id, default: 0] < 5
    }

    func incrementShoutoutsCounter(_ article: Article) {
        articleShoutoutsCounter[article.id, default: 0] += 1
    }

    func set(article: Article, isSaved: Bool, bookmarkRequestInProgress: Binding<Bool>) {
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
            cancellables[.bookmark(article)] = Network.shared.publisher(for: BookmarkArticleMutation(uuid: uuid))
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
            savedArticleIDs.removeAll(where: { $0 == article.id })
        }
    }

    func set(publication: Publication, isFollowed: Bool, followRequestInProgress: Binding<Bool>) {
        @Binding var requestInProgress: Bool
        _requestInProgress = followRequestInProgress
        
        guard let uuid = uuid else {
            // User has not finished onboarding
            if isFollowed {
                if !followedPublicationSlugs.contains(publication.slug) {
                    followedPublicationSlugs.insert(publication.slug, at: 0)
                }
            } else {
                followedPublicationSlugs.removeAll(where: { $0 == publication.slug })
            }
            requestInProgress = false
            return
        }
        
        if isFollowed {
            let followMutation = FollowPublicationMutation(slug: publication.slug, uuid: uuid)
            cancellables[.follow(publication)] = Network.shared.publisher(for: followMutation)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error: FollowPublicationMutation failed on UserData: \(error.localizedDescription)")
                    }
                    requestInProgress = false
                } receiveValue: { value in
                    if !self.followedPublicationSlugs.contains(publication.slug) {
                        self.followedPublicationSlugs.insert(publication.slug, at: 0)
                    }
                }

        } else {
            let unfollowMutation = UnfollowPublicationMutation(slug: publication.slug, uuid: uuid)
            cancellables[.unfollow(publication)] = Network.shared.publisher(for: unfollowMutation)
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
}

extension UserData {
    private enum Mutation: Hashable {
        case follow(Publication), unfollow(Publication), bookmark(Article)
    }
}
