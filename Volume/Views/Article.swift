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
    read_duration: 5,
    date: "Today")

let articleData = [
    article, article, article, article, article, article, article
]

struct Article: Identifiable {
    
    var id = UUID()
    
    var image: String
    var publication: String
    var title: String
    var read_duration: Int
    var date: String
    
    init(image: String, publication: String, title: String, read_duration: Int, date: String) {
        self.image = image
        self.publication = publication
        self.title = title
        self.read_duration = read_duration
        self.date = date
    }
    
}
