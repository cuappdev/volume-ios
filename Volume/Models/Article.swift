//
//  Article.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - ArticleQueryResult

/// An umbrella type for minimizing repetition of the code that casts query results to
/// `Article`s. This type is not to be explicitly referenced outside of this file. Cast
/// instances to `Article`s instead and then work with that type.
protocol ArticleQueryResult {
    var articleUrl: String { get }
    var date: String { get }
    var id: String { get }
    var imageUrl: String { get }
    var shoutouts: Double { get }
    var title: String { get }
    var publicationName: String { get }
}

extension GetTrendingArticlesQuery.Data.Article: ArticleQueryResult {
    var publicationName: String { publication.name }
}

extension GetArticlesByPublicationIdQuery.Data.Article: ArticleQueryResult {
    var publicationName: String { publication.name }
}

extension GetArticlesAfterDateQuery.Data.Article: ArticleQueryResult {
    var publicationName: String { publication.name }
}

extension GetArticleByIdQuery.Data.Article: ArticleQueryResult {
    var publicationName: String { publication.name }
}

// MARK: - Article

struct Article: Hashable, Identifiable {
    let articleURL: URL?
    let date: Date
    let id: String
    let imageURL: URL?
    let publicationName: String
    let shoutOuts: Int
    let title: String
    
    init(
        articleURL: URL?,
        date: Date,
        id: String,
        imageURL: URL?,
        publicationName: String,
        shoutOuts: Int,
        title: String
    ) {
        self.articleURL = articleURL
        self.date = date
        self.id = id
        self.imageURL = imageURL
        self.publicationName = publicationName
        self.shoutOuts = shoutOuts
        self.title = title
    }
    
    init(from article: ArticleQueryResult) {
        articleURL = URL(string: article.articleUrl)
        date = Date.from(iso8601: article.date)
        id = article.id
        imageURL = URL(string: article.imageUrl)
        publicationName = article.publicationName
        shoutOuts = Int(article.shoutouts)
        title = article.title
    }
}

extension Array where Element == Article {
    init(_ articles: [ArticleQueryResult]) {
        self.init(articles.map(Article.init))
    }
}
