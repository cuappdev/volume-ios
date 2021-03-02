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
    let numArticles: Int
    let id: String
    let profileImageUrl: URL?
    let backgroundImageUrl: URL?
    let recent: String?
    let shoutouts: Int
    let websiteUrl: URL?
    let socials: [Social]
    
    struct Social: Equatable, Hashable {
        let name: String
        let url: URL
    }
    
    init(from publication: PublicationFields) {
        bio = publication.bio
        name = publication.name
        numArticles = Int(publication.numArticles)
        id = publication.id
        profileImageUrl = URL(string: publication.profileImageUrl)
        backgroundImageUrl = URL(string: publication.backgroundImageUrl)
        recent = publication.mostRecentArticle?.title
        shoutouts = Int(publication.shoutouts)
        websiteUrl = URL(string: publication.websiteUrl)
        socials = publication.socials.compactMap {
            if let url = URL(string: $0.url) {
                return Social(name: $0.social, url: url)
            }
            return nil
        }
    }
}

extension Array where Element == Publication {
    init(_ articles: [PublicationFields]) {
        self.init(articles.map(Publication.init))
    }
}
