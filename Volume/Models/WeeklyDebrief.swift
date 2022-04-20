//
//  WeeklyDebrief.swift
//  Volume
//
//  Created by Hanzheng Li on 11/17/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import Foundation

struct WeeklyDebrief: Codable {
    let creationDate: Date
    let expirationDate: Date
    let numBookmarkedArticles: Int
    let numReadArticles: Int
    let numShoutouts: Int
    let readArticleIDs: [ArticleID]
    let randomArticleIDs: [ArticleID]
    
    init(from weeklyDebrief: GetWeeklyDebriefQuery.Data.User.WeeklyDebrief) {
        creationDate = Date.from(iso8601: weeklyDebrief.creationDate)
        expirationDate = Date.from(iso8601: weeklyDebrief.expirationDate)
        numBookmarkedArticles = Int(weeklyDebrief.numBookmarkedArticles)
        numReadArticles = Int(weeklyDebrief.numReadArticles)
        numShoutouts = Int(weeklyDebrief.numShoutouts)
        readArticleIDs = weeklyDebrief.readArticles.map(\.fragments.articleFields.id)
        randomArticleIDs = weeklyDebrief.randomArticles.map(\.fragments.articleFields.id)
    }
    
    init(creationDate: Date, expirationDate: Date, numBookmarkedArticles: Int, numReadArticles: Int, numShoutouts: Int, readArticleIDs: [ArticleID], randomArticleIDs: [ArticleID]) {
        self.creationDate = creationDate
        self.expirationDate = expirationDate
        self.numBookmarkedArticles = numBookmarkedArticles
        self.numReadArticles = numReadArticles
        self.numShoutouts = numShoutouts
        self.readArticleIDs = readArticleIDs
        self.randomArticleIDs = randomArticleIDs
    }
    
    static func dummyDebrief() -> WeeklyDebrief {
        WeeklyDebrief(
            creationDate: Date(),
            expirationDate: Date(),
            numBookmarkedArticles: 33,
            numReadArticles: 22,
            numShoutouts: 11,
            readArticleIDs: ["618f63022fef10d6b75ec9a5", "618f63022fef10d6b75ec9a6"],
            randomArticleIDs: ["618f63022fef10d6b75ec9ae", "618f63022fef10d6b75ec9b5"]
        )
    }
}
