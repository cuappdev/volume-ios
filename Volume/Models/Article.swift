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
    var _publication: PublicationQueryResult { get }
}

extension GetTrendingArticlesQuery.Data.Article: ArticleQueryResult {
    var _publication: PublicationQueryResult { publication }
}

extension GetArticlesByPublicationIdQuery.Data.Article: ArticleQueryResult {
    var _publication: PublicationQueryResult { publication }
}

extension GetArticlesAfterDateQuery.Data.Article: ArticleQueryResult {
    var _publication: PublicationQueryResult { publication }
}

extension GetArticleByIdQuery.Data.Article: ArticleQueryResult {
    var _publication: PublicationQueryResult { publication }
}

// MARK: - Article

struct Article: Hashable, Identifiable {
    let articleUrl: URL?
    let date: Date
    let id: String
    let imageUrl: URL?
    let publication: Publication
    let shoutouts: Int
    let title: String
    
    init(from article: ArticleQueryResult) {
        articleUrl = URL(string: article.articleUrl)
        date = Date.from(iso8601: article.date)
        id = article.id
        imageUrl = URL(string: article.imageUrl)
        publication = Publication(from: article._publication)
        shoutouts = Int(article.shoutouts)
        title = article.title
    }
}

extension Array where Element == Article {
    init(_ articles: [ArticleQueryResult]) {
        self.init(articles.map(Article.init))
    }
}
