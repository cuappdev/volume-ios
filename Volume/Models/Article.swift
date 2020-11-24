//
//  Article.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

// MARK: start of dummy data
private let slopeMedia =
    Article(
        date: Date(timeInterval: -1000, since: Date()),
        image: "iceCream",
        isSaved: false,
        publication: "Slope Media",
        shoutOuts: 123,
        title: "Top 6 Ice Cream Places in Ithaca: Ranked"
    )

private let cuNooz =
    Article(
        date: Date(timeInterval: -10000, since: Date()),
        image: "tcatkiss",
        isSaved: true,
        publication: "CU Nooz",
        shoutOuts: 12,
        title: "Students Low On Cash Can Now Give TCAT Bus Drivers a Kiss On The Lips As Payment"
    )

private let cremeDeCornell =
    Article(
        date: Date(timeInterval: -20000, since: Date()),
        image: "bulgogi",
        isSaved: false,
        publication: "Creme de Cornell",
        shoutOuts: 1200,
        title: "Vegan Bulgogi"
    )

private let cuReview =
    Article(
        date: Date(timeInterval: -20, since: Date()),
        image: nil,
        isSaved: false,
        publication: "Cornell Review",
        shoutOuts: 0,
        title: "The Cornell Student Body’s Problem with Tolerance"
    )

let articleData = [
    cuReview, slopeMedia, cremeDeCornell, slopeMedia, cremeDeCornell,
    slopeMedia, cuReview, cremeDeCornell, cuNooz, cremeDeCornell, cuNooz
]
// MARK: end of dummy data

struct Article: Hashable, Identifiable {
    let id = UUID()
    
    var date: Date
    var image: String?
    var isSaved: Bool
    var publication: String
    var shoutOuts: Int
    var title: String
    
    init(date: Date, image: String?, isSaved: Bool, publication: String, shoutOuts: Int, title: String) {
        self.date = date
        self.image = image
        self.isSaved = isSaved
        self.publication = publication
        self.shoutOuts = shoutOuts
        self.title = title
    }
}
