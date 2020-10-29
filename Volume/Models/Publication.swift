//
//  Publication.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

let example = Publication(
    description: "A short description that might take two lines.",
    name: "Cornell Review",
    image: "todo",
    recent: "American History: Nov 3 2020")

let publicationsData = [
    example, example, example, example, example, example, example, example, example, example, example, example
]

struct Publication: Identifiable {
    
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
