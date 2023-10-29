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
    let categorySlug: String
    let endDate: Date
    let flyerUrl: URL?
    let imageUrl: URL?
    let location: String
    let organization: Organization
    let organizationSlug: String
    let startDate: Date
    let timesClicked: Int
    let title: String
    let trendiness: Int

    init(from flyer: FlyerFields) {
        self.id = flyer.id
        self.categorySlug = flyer.categorySlug
        self.endDate = Date.from(iso8601: flyer.endDate)
        self.flyerUrl = {
            guard let stringUrl = flyer.flyerUrl else { return nil }
            return URL(string: stringUrl)
        }()
        self.imageUrl = URL(string: flyer.imageUrl)
        self.location = flyer.location
        self.organization = Organization(from: flyer.organization.fragments.organizationFields)
        self.organizationSlug = flyer.organizationSlug
        self.startDate = Date.from(iso8601: flyer.startDate)
        self.timesClicked = Int(flyer.timesClicked)
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
