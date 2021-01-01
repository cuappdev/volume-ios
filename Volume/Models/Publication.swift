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
    let profileImageUrl: URL?
    let backgroundImageUrl: URL?
    let recent: String
    let shoutouts: Int
    let websiteUrl: URL?
    let socials: [String : String] = [:]
    
    init(from publication: GetAllPublicationsQuery.Data.Publication) {
        bio = publication.bio
        name = publication.name
        id = publication.id
        // TODO: Delete this once backend is updated
        profileImageUrl = URL(
            string: publication.profileImageUrl
        )
        backgroundImageUrl = URL(
            string: publication.backgroundImageUrl
        )
        recent = publication.mostRecentArticle.title
        shoutouts = Int(publication.shoutouts)
        websiteUrl = URL(string: publication.websiteUrl)
    }
}

extension Array where Element == Publication {
    init(_ articles: [GetAllPublicationsQuery.Data.Publication]) {
        self.init(articles.map(Publication.init))
    }
}
