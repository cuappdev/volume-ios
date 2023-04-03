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

let newDestinations = Flyer(date: Date(), description: "", id: "1", imageURL: "", isFiltered: false, location: "Bailey Hall", organization: breakFree, organizationSlug: "breakfree", title: "New Destinations")
let bowlingSocial = Flyer(date: Date(), description: "", id: "2", imageURL: "", isFiltered: false, location: "Helen Newman Hall", organization: csa, organizationSlug: "csa", title: "Bowling Social")
let springFormal = Flyer(date: Date(), description: "", id: "3", imageURL: "", isFiltered: false, location: "Big Red Barn", organization: csa, organizationSlug: "csa", title: "Spring Formal")
let pulse = Flyer(date: Date(), description: "", id: "4", imageURL: "", isFiltered: false, location: "Bailey Hall", organization: yamatai, organizationSlug: "yamatai", title: "Pulse")
let asiaverse = Flyer(date: Date(), description: "", id: "5", imageURL: "", isFiltered: false, location: "Klarman Hall", organization: capsu, organizationSlug: "capsu", title: "Into the Asiaverse")

struct FlyerDummyData {
    
    static let thisWeekFlyers = [asiaverse, newDestinations, pulse]

}
