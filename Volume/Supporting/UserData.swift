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
    }
    
    func set(deviceToken: String) {
        UserDefaults.standard.setValue(deviceToken, forKey: deviceTokenKey)
    }
    
    func createUser() {
        if let deviceToken = UserDefaults.standard.string(forKey: deviceTokenKey) {
            print("Creating user with deviceToken \(deviceToken) and following \(followedPublicationIDs)...")
            cancellables[.createUser] = Network.shared.publisher(for: CreateUserMutation(deviceToken: deviceToken, followedPublicationIDs: followedPublicationIDs))
                .map { $0.user.uuid }
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("An error occurred in creating user: \(error)")
                    }
                } receiveValue: { uuid in
                    // cache this UUID to use later when mutating user-specific info
                    print("User created on backend with UUID: \(uuid)")
                    UserDefaults.standard.setValue(uuid, forKey: self.userUUIDKey)
                }
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
        if isSaved {
            if !savedArticleIDs.contains(article.id) {
                savedArticleIDs.insert(article.id, at: 0)
            }
        } else {
            savedArticleIDs.removeAll(where: { $0 == article.id })
        }
    }

    func set(publication: Publication, isFollowed: Bool) {
        if isFollowed {
            if !followedPublicationIDs.contains(publication.id) {
                followedPublicationIDs.insert(publication.id, at: 0)
            }
        } else {
            followedPublicationIDs.removeAll(where: { $0 == publication.id })
        }
    }
}

extension UserData {
    enum Mutation {
        case createUser, followPublication, unfollowPublication
    }
}
