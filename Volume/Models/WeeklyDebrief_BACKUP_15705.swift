//
//  WeeklyDebrief.swift
//  Volume
//
//  Created by Hanzheng Li on 11/17/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

<<<<<<< HEAD
import Foundation

struct WeeklyDebrief: Codable {
    let creationDate: Date
    let expirationDate: Date
    let numShoutouts: Int
    let numReadArticles: Int
    let numBookmarkedArticles: Int
    let readArticleIDs: [ArticleID]
    let randomArticleIDs: [ArticleID]
=======
import Apollo
import Foundation

struct WeeklyDebrief {
    /* createdAt
     expirationDate
     numShoutouts
     readArticles {
       ...articleFields
     }
     randomArticles {
       ...articleFields
     }
     */
    var creationDate: Date
    var expirationDate: Date
    var numShoutouts: Int
    var numReadArticles: Int
    var numBookmarkedArticles: Int
    var readArticles: [Article]
    var randomArticles: [Article]
>>>>>>> 3b26d1b (Update schema, add query and models)
    
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
<<<<<<< HEAD
        readArticleIDs = weeklyDebrief.readArticles.map(\.fragments.articleFields.id)
        randomArticleIDs = weeklyDebrief.randomArticles.map(\.fragments.articleFields.id)
    }
=======
        readArticles = [Article](weeklyDebrief.readArticles.map(\.fragments.articleFields))
        randomArticles = [Article](weeklyDebrief.randomArticles.map(\.fragments.articleFields))
    }
    
>>>>>>> 3b26d1b (Update schema, add query and models)
}
