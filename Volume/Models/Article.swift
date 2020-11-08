//
//  Article.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

private let article = Article(
    image: "kale",
    publication: "Scientific American",
    title: "Correlation Between Hello World Search Frequency and Computer Science Salaries",
    shout_outs: 5,
    date: "Today")

let articleData = [
    article, article, article, article, article, article, article
]

struct Article: Identifiable {
    
    var id = UUID()
    
    var image: String?
    var publication: String
    var title: String
    var shout_outs: Int
    var date: String
    
    init(image: String, publication: String, title: String, shout_outs: Int, date: String) {
        self.image = image
        self.publication = publication
        self.title = title
        self.shout_outs = shout_outs
        self.date = date
    }
    
}
