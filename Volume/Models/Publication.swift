//
//  Publication.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Publication: Hashable, Identifiable {
    let bio: String
    let name: String
    let id: String
    let profileImageURL: URL?
    let backgroundImageURL: URL?
    let recent: String
    let shoutouts: Int
    let websiteURL: URL?
    let socials: [String : String] = [:]
    
    init(
        bio: String,
        name: String,
        id: String,
        profileImageURL: URL?,
        backgroundImageURL: URL?,
        recent: String,
        shoutouts: Int,
        websiteURL: URL?
    ) {
//        self.articles = articles
        self.bio = bio
        self.name = name
        self.id = id
        self.profileImageURL = profileImageURL
        self.backgroundImageURL = backgroundImageURL
        self.recent = recent
        self.shoutouts = shoutouts
        self.websiteURL = websiteURL
    }
    
    init(from publication: GetAllPublicationsQuery.Data.Publication) {
        bio = publication.bio
        name = publication.name
        id = publication.id
        // TODO: Delete this once backend is updated
        profileImageURL = URL(
            string: publication.profileImageUrl
        )
        backgroundImageURL = URL(
            string: publication.backgroundImageUrl
        )
        recent = publication.mostRecentArticle.title
        shoutouts = Int(publication.shoutouts)
        websiteURL = URL(string: publication.websiteUrl)
    }
}

extension Array where Element == Publication {
    init(_ articles: [GetAllPublicationsQuery.Data.Publication]) {
        self.init(articles.map(Publication.init))
    }
}
