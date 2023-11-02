//
//  Publication.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Publication: Hashable, Identifiable {

    let backgroundImageUrl: URL?
    let bio: String
    var id: String {
        slug
    }
    let name: String
    let numArticles: Int
    let profileImageUrl: URL?
    let recent: String?
    let shoutouts: Int
    let slug: String
    let socials: [Social]
    let websiteUrl: URL?

    struct Social: Equatable, Hashable {
        let name: String
        let url: URL
    }

    init(from publication: PublicationFields) {
        backgroundImageUrl = URL(string: publication.backgroundImageUrl)
        bio = publication.bio
        name = publication.name
        numArticles = Int(publication.numArticles)
        profileImageUrl = URL(string: publication.profileImageUrl)
        recent = publication.mostRecentArticle?.title
        shoutouts = Int(publication.shoutouts)
        slug = publication.slug
        socials = publication.socials.compactMap {
            if let url = URL(string: $0.url) {
                return Social(name: $0.social, url: url)
            }
            return nil
        }
        websiteUrl = URL(string: publication.websiteUrl)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Publication {

    enum ContentType {
        case articles, magazines
    }

}

extension Array where Element == Publication {

    init(_ articles: [PublicationFields]) {
        self.init(articles.map(Publication.init))
    }

}
