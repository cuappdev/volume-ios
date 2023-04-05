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
    let articleUrl: URL?
    let date: Date
    let id: String
    let imageUrl: URL?
    let isTrending: Bool
    let isNsfw: Bool
    let publication: Publication
    let publicationSlug: String
    let shoutouts: Int
    let title: String
    let trendiness: Int

    init(from article: ArticleFields) {
        articleUrl = URL(string: article.articleUrl)
        date = Date.from(iso8601: article.date)
        id = article.id
        imageUrl = URL(string: article.imageUrl)
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
    init(_ articles: [ArticleFields]) {
        self.init(articles.map(Article.init))
    }
}
