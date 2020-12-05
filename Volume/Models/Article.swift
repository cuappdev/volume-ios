//
//  Article.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import SwiftUI

struct Article: Codable, Hashable, Identifiable {
    let articleURL: URL?
    let date: Date
    let id: String
    let imageURL: URL?
    var isSaved: Bool {
        get { UserData.default.savedArticleIDs.contains(id) }
        nonmutating set { UserData.default.setArticle(id: id, isSaved: newValue) }
    }
    let publication: Publication
    let shoutOuts: Int
    let title: String
    
    init(
        articleURL: URL?,
        date: Date,
        id: String,
        imageURL: URL?,
        publication: Publication,
        shoutOuts: Int,
        title: String
    ) {
        self.articleURL = articleURL
        self.date = date
        self.id = id
        self.imageURL = imageURL
        self.publication = publication
        self.shoutOuts = shoutOuts
        self.title = title
    }
    
    init(from article: GetHomeArticlesQuery.Data.Trending) {
        articleURL = URL(string: article.articleUrl)
        date = Date.from(iso8601: article.date)
        id = article.id
        imageURL = URL(string: article.imageUrl)
        publication = Publication(bio: "", name: "", id: "", imageURL: nil, recent: "", shoutouts: 0, websiteURL: nil)
        shoutOuts = Int(article.shoutouts)
        title = article.title
    }
    
    init(from article: GetHomeArticlesQuery.Data.Following) {
        articleURL = URL(string: article.articleUrl)
        date = Date.from(iso8601: article.date)
        id = article.id
        imageURL = URL(string: article.imageUrl)
        publication = Publication(bio: "", name: "", id: "", imageURL: nil, recent: "", shoutouts: 0, websiteURL: nil)
        shoutOuts = Int(article.shoutouts)
        title = article.title
    }
    
    init(from article: GetHomeArticlesQuery.Data.Other) {
        articleURL = URL(string: article.articleUrl)
        date = Date.from(iso8601: article.date)
        id = article.id
        imageURL = URL(string: article.imageUrl)
        publication = Publication(bio: "", name: "", id: "", imageURL: nil, recent: "", shoutouts: 0, websiteURL: nil)
        shoutOuts = Int(article.shoutouts)
        title = article.title
    }
    
    init(from article: GetArticleByIdQuery.Data.Article) {
        articleURL = URL(string: article.articleUrl)
        date = Date.from(iso8601: article.date)
        id = article.id
        imageURL = URL(string: article.imageUrl)
        publication = Publication(bio: "", name: "", id: "", imageURL: nil, recent: "", shoutouts: 0, websiteURL: nil)
        shoutOuts = Int(article.shoutouts)
        title = article.title
    }
}

extension Array where Element == Article {
    init(_ articles: [GetHomeArticlesQuery.Data.Trending]) {
        self.init(articles.map(Article.init))
    }
    
    init(_ articles: [GetHomeArticlesQuery.Data.Following]) {
        self.init(articles.map(Article.init))
    }
    
    init(_ articles: [GetHomeArticlesQuery.Data.Other]) {
        self.init(articles.map(Article.init))
    }
    
    init(_ articles: [GetArticleByIdQuery.Data.Article]) {
        self.init(articles.map(Article.init))
    }
}
