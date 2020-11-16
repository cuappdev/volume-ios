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
        publication: "Slope Media",
        saved: false,
        shout_outs: 123,
        title: "Top 6 Ice Cream Places in Ithaca: Ranked"
    )

private let cuNooz =
    Article(
        date: Date(timeInterval: -10000, since: Date()),
        image: "tcatkiss",
        publication: "CU Nooz",
        saved: true,
        shout_outs: 12,
        title: "Students Low On Cash Can Now Give TCAT Bus Drivers a Kiss On The Lips As Payment"
    )

private let cremeDeCornell =
    Article(
        date: Date(timeInterval: -20000, since: Date()),
        image: "bulgogi",
        publication: "Creme de Cornell",
        saved: false,
        shout_outs: 1200,
        title: "Vegan Bulgogi"
    )

private let cuReview =
    Article(
        date: Date(timeInterval: -20, since: Date()),
        image: nil,
        publication: "Cornell Review",
        saved: false,
        shout_outs: 0,
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
    var publication: String
    var saved: Bool
    var shout_outs: Int
    var title: String
    
    init(date: Date, image: String?, publication: String, saved: Bool, shout_outs: Int, title: String) {
        self.date = date
        self.image = image
        self.publication = publication
        self.saved = saved
        self.shout_outs = shout_outs
        self.title = title
    }
}
