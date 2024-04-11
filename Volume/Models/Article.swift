//
//  Article.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import SwiftUI

typealias ArticleID = String

struct Article: ReadableContent {

    let id: String
    let articleUrl: URL?
    let date: Date
    let imageUrl: URL?
    let isTrending: Bool
    let isNsfw: Bool
    let publication: Publication
    let publicationSlug: String
    let shoutouts: Int
    let title: String
    let trendiness: Int

    init(from article: VolumeAPI.ArticleFields) {
        id = article.id
        articleUrl = URL(string: article.articleURL)
        date = Date.from(iso8601: article.date)
        imageUrl = URL(string: article.imageURL)
        isTrending = article.isTrending
        isNsfw = article.nsfw
        publication = Publication(from: article.publication.fragments.publicationFields)
        publicationSlug = article.publicationSlug
        shoutouts = Int(article.shoutouts)
        title = article.title
        trendiness = Int(article.trendiness)
    }

}

extension Array where Element == Article {

    init(_ articles: [VolumeAPI.ArticleFields]) {
        self.init(articles.map(Article.init))
    }

}
