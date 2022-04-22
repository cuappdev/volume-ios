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
}
