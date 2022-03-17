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
    let numShoutouts: Int
    let numReadArticles: Int
    let numBookmarkedArticles: Int
    let readArticleIDs: [ArticleID]
    let randomArticleIDs: [ArticleID]
    
    init(from weeklyDebrief: GetWeeklyDebriefQuery.Data.User.WeeklyDebrief) {
        creationDate = Date.from(iso8601: weeklyDebrief.creationDate)
        expirationDate = Date.from(iso8601: weeklyDebrief.expirationDate)
        numShoutouts = Int(weeklyDebrief.numShoutouts)
        numReadArticles = Int(weeklyDebrief.numReadArticles)
        numBookmarkedArticles = Int(weeklyDebrief.numBookmarkedArticles)
        readArticleIDs = weeklyDebrief.readArticles.map(\.fragments.articleFields.id)
        randomArticleIDs = weeklyDebrief.randomArticles.map(\.fragments.articleFields.id)
    }
    
    init(creationDate: Date, expirationDate: Date, numShoutouts: Int, numReadArticles: Int, numBookmarkedArticles: Int, readArticleIDs: [ArticleID], randomArticleIDs: [ArticleID]) {
        self.creationDate = creationDate
        self.expirationDate = expirationDate
        self.numShoutouts = numShoutouts
        self.numReadArticles = numReadArticles
        self.numBookmarkedArticles = numBookmarkedArticles
        self.readArticleIDs = readArticleIDs
        self.randomArticleIDs = randomArticleIDs
    }
    
    static func dummyDebrief() -> WeeklyDebrief {
        WeeklyDebrief(
            creationDate: Date(),
            expirationDate: Date(),
            numShoutouts: 11,
            numReadArticles: 22,
            numBookmarkedArticles: 33,
            readArticleIDs: ["618f63022fef10d6b75ec9a5", "618f63022fef10d6b75ec9a6"],
            randomArticleIDs: ["618f63022fef10d6b75ec9ae", "618f63022fef10d6b75ec9b5"]
        )
    }
}
