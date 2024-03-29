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
    let numReadArticles: Int
    let numShoutouts: Int
    let readArticleIDs: [ArticleID]
    let randomArticleIDs: [ArticleID]
    let readMagazineIDs: [MagazineID]

    init(from weeklyDebrief: GetWeeklyDebriefQuery.Data.User.WeeklyDebrief) {
        creationDate = Date.from(iso8601: weeklyDebrief.creationDate)
        expirationDate = Date.from(iso8601: weeklyDebrief.expirationDate)
        numReadArticles = Int(weeklyDebrief.numReadArticles)
        numShoutouts = Int(weeklyDebrief.numShoutouts)
        readArticleIDs = weeklyDebrief.readArticles.map(\.fragments.articleFields.id)
        randomArticleIDs = weeklyDebrief.randomArticles.map(\.fragments.articleFields.id)
        readMagazineIDs = weeklyDebrief.readMagazines.map(\.fragments.magazineFields.id)
    }

    var isExpired: Bool {
        let comparisonResult = Calendar.current.compare(expirationDate, to: Date.now, toGranularity: .day)
        return comparisonResult != .orderedDescending
    }
}
