//
//  Flyer.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

typealias FlyerID = String

struct Flyer: Hashable, Identifiable {
    
    let id: String
    let endDate: Date
    let flyerUrl: URL?
    let imageUrl: URL?
    let isTrending: Bool
    let location: String
    let nsfw: Bool
    let organizations: [Organization]
    let organizationSlugs: [String]
    let shoutouts: Int
    let startDate: Date
    let title: String
    let trendiness: Int
    
    init(from flyer: FlyerFields) {
        self.id = flyer.id
        self.endDate = Date.from(iso8601: flyer.endDate)
        self.flyerUrl = URL(string: flyer.flyerUrl)
        self.imageUrl = URL(string: flyer.imageUrl)
        self.isTrending = Bool(flyer.isTrending)
        self.location = flyer.location
        self.nsfw = flyer.nsfw
        self.organizations = flyer.organizations.map { Organization(from: $0.fragments.organizationFields) }
        self.organizationSlugs = flyer.organizationSlugs
        self.shoutouts = Int(flyer.shoutouts)
        self.startDate = Date.from(iso8601: flyer.startDate)
        self.title = flyer.title
        self.trendiness = Int(flyer.trendiness)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

extension Array where Element == Flyer {

    init(_ flyers: [FlyerFields]) {
        self.init(flyers.map(Flyer.init))
    }
    
}
