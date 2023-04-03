//
//  Organization.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

// TODO: Reimplement once backend is finished

struct Organization: Hashable, Identifiable {
    
    let backgroundImageURL: String
    let bio: String
    let bioShort: String
    let contentType: Organization.ContentType
    let id: String
    let name: String
    let profileImageURL: String
    let rssName: String
    let rssURL: String?
    let slug: String
    let shoutouts: Int? = 0
    let websiteURL: String
    
    // TODO: init for OrganizationFields
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Organization {

    enum ContentType {
        case academic, art, awareness, comedy, cultural, dance, foodDrinks, greekLife, music, socialJustice, spiritual, sports
    }
    
    static func contentTypeString(type: Organization.ContentType) -> String {
        switch type {
        case .academic:
            return "Academic"
        case .art:
            return "Art"
        case .awareness:
            return "Awareness"
        case .comedy:
            return "Comedy"
        case .cultural:
            return "Cultural"
        case .dance:
            return "Dance"
        case .foodDrinks:
            return "Food & Drinks"
        case .greekLife:
            return "Greek Life"
        case .music:
            return "Music"
        case .socialJustice:
            return "Social Justice"
        case .spiritual:
            return "Spritual"
        case .sports:
            return "Sports"
        }
    }

}

// TODO: Remove dummy data below

let breakFree = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .dance, id: "1", name: "Break Free", profileImageURL: "", rssName: "", rssURL: "", slug: "breakfree", websiteURL: "")
let yamatai = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .music, id: "2", name: "Yamatai", profileImageURL: "", rssName: "", rssURL: "", slug: "breakfree", websiteURL: "")
let csa = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .cultural, id: "3", name: "Chinese Student Association", profileImageURL: "", rssName: "", rssURL: "", slug: "csa", websiteURL: "")
let capsu = Organization(backgroundImageURL: "", bio: "", bioShort: "", contentType: .cultural, id: "4", name: "Cornell Asian Pacific Student Union", profileImageURL: "", rssName: "", rssURL: "", slug: "capsu", websiteURL: "")
