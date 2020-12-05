//
//  FollowingData.swift
//  Volume
//
//  Created by Daniel Vebman on 12/6/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

class UserData: ObservableObject {
    private let articlesKey = "savedArticlesData"
    private let publicationsKey = "savedPublicationsData"
    
    static let `default` = UserData()
    
    @Published private(set) var savedArticleIDs: [String] = [] {
        didSet {
            UserDefaults.standard.setValue(savedArticleIDs, forKey: articlesKey)
        }
    }
    
    @Published private(set) var followedPublicationIDs: [String] = [] {
        didSet {
            UserDefaults.standard.setValue(followedPublicationIDs, forKey: publicationsKey)
        }
    }
    
    func setArticle(id: String, isSaved: Bool) {
        if isSaved {
            if !savedArticleIDs.contains(id) {
                savedArticleIDs.insert(id, at: 0)
            }
        } else {
            savedArticleIDs.removeAll(where: { $0 == id })
        }
    }
    
    func setPublication(id: String, isFollowed: Bool) {
        if isFollowed {
            if !followedPublicationIDs.contains(id) {
                followedPublicationIDs.insert(id, at: 0)
            }
        } else {
            followedPublicationIDs.removeAll(where: { $0 == id })
        }
    }
    
    init() {
        if let ids = UserDefaults.standard.object(forKey: articlesKey) as? [String] {
            savedArticleIDs = ids
        }
        
        if let ids = UserDefaults.standard.object(forKey: publicationsKey) as? [String] {
            followedPublicationIDs = ids
        }
    }
}
