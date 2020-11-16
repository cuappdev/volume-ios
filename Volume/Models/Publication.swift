//
//  Publication.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

// MARK: start of dummy data
let cremeDeCornell = Publication(
    description: "Passionate food enthusiasts coming together to publish a diversity of recipes and stories.",
    name: "Creme de Cornell",
    image: "creme",
    recent: "Kale Chips")

let cremeDeCornell2 = Publication(
    description: "Passionate food enthusiasts",
    name: "Creme",
    image: "creme",
    recent: "Kale Chips")

let publicationsData = [
    cremeDeCornell, cremeDeCornell2
]
// MARK: end of dummy data

struct Publication: Hashable, Identifiable {
    var id = UUID()
    
    var description: String
    var name: String
    var image: String
    var recent: String
    
    init(description: String, name: String, image: String, recent: String) {
        self.description = description
        self.name = name
        self.image = image
        self.recent = recent
    }
}
