//
//  Publication.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

/// An umbrella type for minimizing repetition of the code that casts query results to
/// `Publication`s. This type is not to be explicitly referenced outside of this file. Cast
/// instances to `Publication`s instead and then work with that type.
protocol PublicationQueryResult {
    var bio: String { get }
    var name: String { get }
    var id: String { get }
    var profileImageUrl: String { get }
    var backgroundImageUrl: String { get }
    var recent: String { get }
    var shoutouts: Double { get }
    var websiteUrl: String { get }
}

extension GetAllPublicationsQuery.Data.Publication: PublicationQueryResult {
    var recent: String { mostRecentArticle.title }
}

extension GetTrendingArticlesQuery.Data.Article.Publication: PublicationQueryResult {
    var recent: String { mostRecentArticle.title }
}

extension GetArticlesByPublicationIdQuery.Data.Article.Publication: PublicationQueryResult {
    var recent: String { mostRecentArticle.title }
}

extension GetArticlesAfterDateQuery.Data.Article.Publication: PublicationQueryResult {
    var recent: String { mostRecentArticle.title }
}

extension GetArticleByIdQuery.Data.Article.Publication: PublicationQueryResult {
    var recent: String { mostRecentArticle.title }
}

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
    
    init(from publication: PublicationQueryResult) {
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
        recent = publication.recent
        shoutouts = Int(publication.shoutouts)
        websiteUrl = URL(string: publication.websiteUrl)
    }
}

extension Array where Element == Publication {
    init(_ articles: [PublicationQueryResult]) {
        self.init(articles.map(Publication.init))
    }
}
