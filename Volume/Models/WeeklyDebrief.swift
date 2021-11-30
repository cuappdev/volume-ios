//
//  WeeklyDebrief.swift
//  Volume
//
//  Created by Hanzheng Li on 11/17/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import Apollo
import Foundation

struct WeeklyDebrief {
    var creationDate: Date
    var expirationDate: Date
    var numShoutouts: Int
    var numReadArticles: Int
    var numBookmarkedArticles: Int
    var readArticles: [Article]
    var randomArticles: [Article]
    
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
        readArticles = [Article](weeklyDebrief.readArticles.map(\.fragments.articleFields))
        randomArticles = [Article](weeklyDebrief.randomArticles.map(\.fragments.articleFields))
    }
    
}
