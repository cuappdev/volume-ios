//
//  Organization.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

struct Organization: Hashable, Identifiable {
    
    var id: String {
        slug
    }
    let backgroundImageUrl: URL?
    let bio: String?
    let categorySlug: OrganizationType
    let name: String
    let profileImageUrl: URL?
    let slug: String
    let shoutouts: Int
    let websiteUrl: URL?
    
    init(from organization: OrganizationFields) {
        self.backgroundImageUrl = {
            guard let stringUrl = organization.backgroundImageUrl else { return nil }
            return URL(string: stringUrl)
        }()
        self.bio = organization.bio
        self.categorySlug = OrganizationType(rawValue: organization.categorySlug) ?? .academic
        self.name = organization.name
        self.profileImageUrl = {
            guard let stringUrl = organization.profileImageUrl else { return nil }
            return URL(string: stringUrl)
        }()
        self.slug = organization.slug
        self.shoutouts = Int(organization.shoutouts)
        self.websiteUrl = URL(string: organization.websiteUrl)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
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

extension Array where Element == Organization {

    init(_ organizations: [OrganizationFields]) {
        self.init(organizations.map(Organization.init))
    }
    
}
