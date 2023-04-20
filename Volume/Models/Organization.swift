//
//  Organization.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

struct Organization: Codable, Identifiable {
    
    let id: String
    let name: String
    let slug: String
    let type: OrganizationType
    
}

enum OrganizationType: String, Codable {
    case all, academic, art, awareness, comedy, cultural, dance, foodDrinks, greekLife, music, socialJustice, spiritual, sports
}

extension Organization {
    
    static func contentTypeString(type: OrganizationType) -> String {
        switch type {
        case .all:
            return "All"
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

// TODO: - Reimplement once backend is finished

//struct Organization: Hashable, Identifiable {
//
//    let backgroundImageURL: String
//    let bio: String
//    let bioShort: String
//    let contentType: Organization.ContentType
//    let id: String
//    let name: String
//    let profileImageURL: String
//    let rssName: String
//    let rssURL: String?
//    let slug: String
//    let shoutouts: Int? = 0
//    let websiteURL: String
//
//    // TODO: init for OrganizationFields
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//}
//
