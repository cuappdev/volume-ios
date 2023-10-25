//
//  Organization.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

struct Organization: Hashable, Identifiable {

    let id: String
    let backgroundImageUrl: URL?
    let bio: String?
    let categorySlug: String
    let name: String
    let profileImageUrl: URL?
    let slug: String
    let shoutouts: Int
    let websiteUrl: URL?

    init(from organization: OrganizationFields) {
        self.id = organization.id
        self.backgroundImageUrl = {
            guard let stringUrl = organization.backgroundImageUrl else { return nil }
            return URL(string: stringUrl)
        }()
        self.bio = organization.bio
        self.categorySlug = organization.categorySlug
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

extension Array where Element == Organization {

    init(_ organizations: [OrganizationFields]) {
        self.init(organizations.map(Organization.init))
    }

}
