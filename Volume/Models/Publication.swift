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
    let recent: String
    let shoutouts: Int
    let websiteURL: URL?
    
    init(
        bio: String,
        name: String,
        id: String,
        imageURL: URL?,
        recent: String,
        shoutouts: Int,
        websiteURL: URL?
    ) {
        self.bio = bio
        self.name = name
        self.id = id
        self.profileImageURL = imageURL
        self.recent = recent
        self.shoutouts = shoutouts
        self.websiteURL = websiteURL
    }
    
    init(from publication: GetAllPublicationsQuery.Data.Publication) {
        bio = publication.bio
        name = publication.name
        id = publication.id
        profileImageURL = URL(string: publication.profileImageUrl)
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
