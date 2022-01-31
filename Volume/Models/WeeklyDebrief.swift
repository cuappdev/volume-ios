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
}
