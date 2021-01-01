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
    var _publication: ArticleQueryResultPublication { get }
}

protocol ArticleQueryResultPublication {
    var id: String { get }
    var name: String { get }
    var profileImageUrl: String { get }
}

extension GetTrendingArticlesQuery.Data.Article: ArticleQueryResult {
    var _publication: ArticleQueryResultPublication { publication }
}
extension GetTrendingArticlesQuery.Data.Article.Publication: ArticleQueryResultPublication { }

extension GetArticlesByPublicationIdQuery.Data.Article: ArticleQueryResult {
    var _publication: ArticleQueryResultPublication { publication }
}
extension GetArticlesByPublicationIdQuery.Data.Article.Publication: ArticleQueryResultPublication { }

extension GetArticlesAfterDateQuery.Data.Article: ArticleQueryResult {
    var _publication: ArticleQueryResultPublication { publication }
}
extension GetArticlesAfterDateQuery.Data.Article.Publication: ArticleQueryResultPublication { }

extension GetArticleByIdQuery.Data.Article: ArticleQueryResult {
    var _publication: ArticleQueryResultPublication { publication }
}
extension GetArticleByIdQuery.Data.Article.Publication: ArticleQueryResultPublication { }

// MARK: - Article

struct Article: Hashable, Identifiable {
    let articleUrl: URL?
    let date: Date
    let id: String
    let imageUrl: URL?
    let publication: Article.Publication
    let shoutOuts: Int
    let title: String
    
    init(from article: ArticleQueryResult) {
        articleUrl = URL(string: article.articleUrl)
        date = Date.from(iso8601: article.date)
        id = article.id
        imageUrl = URL(string: article.imageUrl)
        publication = Publication(from: article._publication)
        shoutOuts = Int(article.shoutouts)
        title = article.title
    }

    struct Publication: Hashable, Identifiable {
        let id: String
        let name: String
        let profileImageUrl: URL?

        init(from publication: ArticleQueryResultPublication) {
            self.id = publication.id
            self.name = publication.name
            self.profileImageUrl = URL(string: publication.profileImageUrl)
        }
    }
}

extension Array where Element == Article {
    init(_ articles: [ArticleQueryResult]) {
        self.init(articles.map(Article.init))
    }
}
