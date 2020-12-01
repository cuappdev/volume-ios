//
//  Publication.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

// MARK: start of dummy data
private let cremeDeCornell = Publication(
    description: "Passionate food enthusiasts coming together to publish a diversity of recipes and stories.",
    name: "Creme de Cornell",
    image: "creme",
    isFollowing: false,
    recent: "Kale Chips"
)

private let cremeDeCornell2 = Publication(
    description: "Passionate food enthusiasts",
    name: "Creme",
    image: "creme",
    isFollowing: false,
    recent: "Kale Chips"
)

let publicationsData = [
    cremeDeCornell, cremeDeCornell2
]
// MARK: end of dummy data

struct Publication: Hashable, Identifiable {
    var id = UUID()
    
    let description: String
    let name: String
    let image: String
    let isFollowing: Bool
    let recent: String
    
}
