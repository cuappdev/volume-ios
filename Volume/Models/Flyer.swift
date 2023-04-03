//
//  Flyer.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

// TODO: Reimplement once backend finishes

typealias FlyerID = String

struct Flyer: Hashable, Identifiable {
    
    let date: Date
    let description: String?
    let id: String
    let imageURL: String
    let isFiltered: Bool
    let isTrending: Bool = false
    let location: String
    let nsfw: Bool = false
    let organization: Organization
    let organizationSlug: String
    let shoutouts: Int = 0
    let title: String
    let trendiness: Int = 0
    
    // TODO: init for FlyerFields
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// TODO: Map FlyerFields to Flyer

// TODO: Remove dummy data below

let newDestinations = Flyer(date: Date(), description: "", id: "1", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/338169147_932070311252779_4414189127983840768_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=107&_nc_ohc=Gt3-HLH_t5YAX-F3sxy&edm=ACWDqb8BAAAA&ccb=7-5&ig_cache_key=MzA2OTQxMDM4MjY5MTg1MDAwNQ%3D%3D.2-ccb7-5&oh=00_AfD4Dv3baghy4hZ2z76kteL1fSdf5b5DJEMD2cRTyT8vdA&oe=642FF16F&_nc_sid=1527a3", isFiltered: false, location: "Bailey Hall", organization: breakFree, organizationSlug: "breakfree", title: "New Destinations")
let bowlingSocial = Flyer(date: Date(), description: "", id: "2", imageURL: "", isFiltered: false, location: "Helen Newman Hall", organization: csa, organizationSlug: "csa", title: "Bowling Social")
let springFormal = Flyer(date: Date(), description: "", id: "3", imageURL: "", isFiltered: false, location: "Big Red Barn", organization: csa, organizationSlug: "csa", title: "Spring Formal")
let pulse = Flyer(date: Date(), description: "", id: "4", imageURL:"https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/327906326_1396763147747609_1888355929101930928_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=105&_nc_ohc=sJUXQYF3vioAX9FkwxG&edm=ACWDqb8BAAAA&ccb=7-5&ig_cache_key=MzA2ODUxMjk0NjkzNDYzMDMzMw%3D%3D.2-ccb7-5&oh=00_AfCYC4SrvxFFnOas0DvYqfkruVKRpwJ_aCXXG6GgZUZoTQ&oe=642F57D4&_nc_sid=1527a3", isFiltered: false, location: "Bailey Hall", organization: yamatai, organizationSlug: "yamatai", title: "Pulse")
let asiaverse = Flyer(date: Date(), description: "", id: "5", imageURL: "https://scontent-lga3-2.cdninstagram.com/v/t51.2885-15/335598882_746161053690881_3957553982610564652_n.jpg?stp=dst-jpg_e35&_nc_ht=scontent-lga3-2.cdninstagram.com&_nc_cat=105&_nc_ohc=R4E9_28Eyj8AX8jKro5&edm=ACWDqb8BAAAA&ccb=7-5&ig_cache_key=MzA1NjQ1MzM0OTU0NTg0NDQwOA%3D%3D.2-ccb7-5&oh=00_AfDcA_HKkqh6JJ1sHi5UqLeyV0HaIOETHpRY-nFdBJY_Qg&oe=642EE524&_nc_sid=1527a3", isFiltered: false, location: "Klarman Hall", organization: capsu, organizationSlug: "capsu", title: "Into the Asiaverse")

struct FlyerDummyData {
    
    static let thisWeekFlyers = [asiaverse, newDestinations, pulse]

}
