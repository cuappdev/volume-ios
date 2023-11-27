//
//  ArticleWidgetProvider.swift
//  Volume
//
//  Created by Vin Bui on 11/11/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import WidgetKit

struct ArticleWidgetProvider: TimelineProvider {

    // MARK: - TimelineProvider Methods

    /// Provides an Article entry representing a placeholder version of the Article widget.
    func placeholder(in context: Context) -> ArticleEntry {
        ArticleEntry(date: .now, article: ArticleWidgetProvider.dummyArticle!)
    }

    /// Provides an Article entry representing the current time and state of the Article widget.
    func getSnapshot(in context: Context, completion: @escaping (ArticleEntry) -> Void) {
        let entry = ArticleEntry(date: .now, article: ArticleWidgetProvider.dummyArticle!)
        completion(entry)
    }

    /// Provides an array of Article entries for the current time and any future times to update the Article widget.
    func getTimeline(in context: Context, completion: @escaping (Timeline<ArticleEntry>) -> Void) {
        WidgetViewModel.shared.fetchTrendingArticles { articles in
            var entries: [ArticleEntry] = []

            // Generate a timeline with at most 4 entries every hour
            for hourOffset in 0..<articles.count {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: .now)!
                let entry = ArticleEntry(date: entryDate, article: articles[hourOffset])
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }

}

extension ArticleWidgetProvider {

    // swiftlint:disable line_length

    /// Dummy article data of a Guac article.
    static var dummyArticle: Article? {
        let data: [String: Any] = [
            "__typename": "Article",
            "id": "654a4be2f910705ca10153ab",
            "articleURL": "https://medium.com/guac-magazine/wandering-beyond-dff949e9de30?source=rss----b3ec7349d5c9---4",
            "date": "2023-11-07T14:21:36.000Z",
            "title": "Wandering Beyond",
            "imageURL": "https://appdev-upload.nyc3.digitaloceanspaces.com/volume/n5t8i1ks.jpe",
            "publicationSlug": "guac",
            "nsfw": false,
            "shoutouts": 0,
            "publication": [
                "__typename": "Publication",
                "slug": "guac",
                "bio": "Guac is an award-winning travel publication run by an interdisciplinary group of students at Cornell University.",
                "name": "Guac Magazine",
                "shoutouts": 275,
                "profileImageURL": "https://raw.githubusercontent.com/cuappdev/assets/master/volume/guac/profile.png",
                "backgroundImageURL": "https://raw.githubusercontent.com/cuappdev/assets/master/volume/guac/background.png",
                "numArticles": 63,
                "websiteURL": "https://medium.com/guac-magazine",
                "socials": [
                    [
                        "__typename": "Social",
                        "social": "insta",
                        "URL": "https://www.instagram.com/guacmag/?hl=en"
                    ],
                    [
                        "__typename": "Social",
                        "social": "facebook",
                        "URL": "https://www.facebook.com/guacmag"
                    ],
                    [
                        "__typename": "Social",
                        "social": "linkedin",
                        "URL": "https://www.linkedin.com/company/guac-magazine/about"
                    ]
                ],
                "mostRecentArticle": [
                    "__typename": "Article",
                    "title": "Bon Voyage to the Dot Com"
                ]
            ],
            "isTrending": false,
            "trendiness": 0
        ]

        // swiftlint:enable line_length

        do {
            let articleQuery = try GetArticleByIdQuery.Data.Article(jsonObject: data)
            return Article(from: articleQuery.fragments.articleFields)
        } catch {
            print("Error in ArticleWidgetProvider: \(error)")
            return nil
        }
    }

}
