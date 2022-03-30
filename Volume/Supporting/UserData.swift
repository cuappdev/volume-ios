//
//  FollowingData.swift
//  Volume
//
//  Created by Daniel Vebman on 12/6/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Combine
import Foundation

class UserData: ObservableObject {
    static let shared = UserData()
    
    private let articlesKey = "savedArticleIds"
    private let publicationsKey = "savedPublicationIds"
    private let articleShoutoutsKey = "articleShoutoutsCounter"
    private let isFirstLaunchKey = "isFirstLaunch"
    private let deviceTokenKey = "deviceToken"
    private let userUUIDKey = "userUUID"
    private let weeklyDebriefKey = "weeklyDebrief"

    /// This cache maps `Article` and `Publication`  ids to shout outs. Its purpose is to allow the UI to
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

    @Published private(set) var followedPublicationIDs: [String] = [] {
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
    
    var deviceToken: String? = nil {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: deviceTokenKey)
        }
    }
    
    private var cancellables: [Mutation : AnyCancellable?] = [:]

    private init() {
        if let ids = UserDefaults.standard.object(forKey: articlesKey) as? [String] {
            savedArticleIDs = ids
        }

        if let ids = UserDefaults.standard.object(forKey: publicationsKey) as? [String] {
            followedPublicationIDs = ids
        }

        if let shoutoutsCounter = UserDefaults.standard.object(forKey: articleShoutoutsKey) as? [String: Int] {
            articleShoutoutsCounter = shoutoutsCounter
        }
        
        if let debriefData = UserDefaults.standard.object(forKey: weeklyDebriefKey) as? Data,
           let debrief = try? JSONDecoder().decode(WeeklyDebrief.self, from: debriefData) {
            weeklyDebrief = debrief
        }
        
        if let deviceToken = UserDefaults.standard.object(forKey: deviceTokenKey) as? String {
            self.deviceToken = deviceToken
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
        followedPublicationIDs.contains(publication.id)
    }

    func toggleArticleSaved(_ article: Article) {
        set(article: article, isSaved: !isArticleSaved(article))
    }

    func togglePublicationFollowed(_ publication: Publication) {
        set(publication: publication, isFollowed: !isPublicationFollowed(publication))
    }

    func canIncrementShoutouts(_ article: Article) -> Bool {
        articleShoutoutsCounter[article.id, default: 0] < 5
    }

    func incrementShoutoutsCounter(_ article: Article) {
        articleShoutoutsCounter[article.id, default: 0] += 1
    }

    func set(article: Article, isSaved: Bool) {
        guard let uuid = uuid else {
            print("Error: received nil for UUID in set(article:isSaved)")
            return
        }
        
        if isSaved {
            if let bookmarkCancellable = cancellables[.bookmark(article)] {
                bookmarkCancellable?.cancel()
            }
            cancellables[.bookmark(article)] = Network.shared.publisher(for: BookmarkArticleMutation(uuid: uuid))
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error: BookmarkArticleMutation failed on UserData: \(error.localizedDescription)")
                    }
                } receiveValue: { _ in
                    if !self.savedArticleIDs.contains(article.id) {
                        self.savedArticleIDs.insert(article.id, at: 0)
                    }
                }
        } else {
            savedArticleIDs.removeAll(where: { $0 == article.id })
        }
    }

    func set(publication: Publication, isFollowed: Bool) {
        guard let uuid = uuid else {
            // User has not finished onboarding
            if isFollowed {
                if !followedPublicationIDs.contains(publication.id) {
                    followedPublicationIDs.insert(publication.id, at: 0)
                }
            } else {
                followedPublicationIDs.removeAll(where: { $0 == publication.id })
            }
            return
        }
        
        if isFollowed {
            // Cancel opposing mutation
            if let unfollowCancellable = cancellables[.unfollow(publication)] {
                unfollowCancellable?.cancel()
            }
            let mutation = FollowPublicationMutation(publicationID: publication.id, uuid: uuid)
            cancellables[.follow(publication)] = Network.shared.publisher(for: mutation)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error: FollowPublicationMutation failed on UserData: \(error.localizedDescription)")
                    }
                } receiveValue: { value in
                    if !self.followedPublicationIDs.contains(publication.id) {
                        self.followedPublicationIDs.insert(publication.id, at: 0)
                    }
                }
        } else {
            // Cancel opposing mutation to
            if let followCancellable = cancellables[.follow(publication)] {
                followCancellable?.cancel()
            }
            cancellables[.unfollow(publication)] = Network.shared.publisher(for: UnfollowPublicationMutation(publicationID: publication.id, uuid: uuid))
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error: UnfollowPublicationMutation failed on UserData: \(error.localizedDescription)")
                    }
                } receiveValue: { _ in
                    self.followedPublicationIDs.removeAll(where: { $0 == publication.id })
                }
        }
    }
}

extension UserData {
    private enum Mutation: Hashable {
        case follow(Publication), unfollow(Publication), bookmark(Article)
    }
}
