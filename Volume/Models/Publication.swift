//
//  Publication.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

let example = Publication(
    description: "Dependent since 1984, bringing the oldest information to the Ithaca Community",
    name: "The Cornell Daily Moon",
    image: "todo",
    recent: "Volume I: 3 Nov. 2020, USA")

let example2 = Publication(
    description: "Dependent since 1984",
    name: "Moon",
    image: "todo",
    recent: "Volume II: 4 Nov. 2020, USA")

let publicationsData = [
    example, example2, example, example, example, example, example, example, example, example, example, example
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
