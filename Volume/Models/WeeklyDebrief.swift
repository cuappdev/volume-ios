//
//  WeeklyDebrief.swift
//  Volume
//
//  Created by Hanzheng Li on 11/17/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import Foundation

struct WeeklyDebrief: Codable {
    var creationDate: Date
    var expirationDate: Date
    var numShoutouts: Int
    var numReadArticles: Int
    var numBookmarkedArticles: Int
    var readArticleIDs: [ArticleID]
    var randomArticleIDs: [ArticleID]
    
    init(from weeklyDebrief: WeeklyDebriefFields) {
        /*
         schema changes required:
         - createdAt -> creationDate
         - numShoutouts, numReadArticles, numBookmarkedArticles -> type Int
         */
        creationDate = Date.from(iso8601: weeklyDebrief.createdAt)
        expirationDate = Date.from(iso8601: weeklyDebrief.expirationDate)
        numShoutouts = Int(weeklyDebrief.numShoutouts)
        numReadArticles = Int(weeklyDebrief.numReadArticles)
        numBookmarkedArticles = Int(weeklyDebrief.numBookmarkedArticles)
        readArticleIDs = weeklyDebrief.readArticles.map(\.fragments.articleFields.id)
        randomArticleIDs = weeklyDebrief.randomArticles.map(\.fragments.articleFields.id)
    }
}
