//
//  Flyer.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

typealias FlyerID = String

struct Flyer: Codable, Identifiable {
    
    let endDate: Date
    let id: String
    let imageURL: String
    let location: String
    let organizations: [Organization]
    let postURL: String
    let startDate: Date
    let title: String
    
}

// TODO: Reimplement once backend finishes

//struct Flyer: Hashable, Identifiable {
//
//    let date: DateInterval
//    let description: String?
//    let id: String
//    let imageURL: String
//    let isFiltered: Bool
//    let isTrending: Bool = false
//    let location: String
//    let nsfw: Bool = false
//    let organizations: [Organization]
//    let organizationSlugs: [String]
//    let pageURL: String
//    let shoutouts: Int = 0
//    let title: String
//    let trendiness: Int = 0
//
//    // TODO: init for FlyerFields
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//}
//
// TODO: Map FlyerFields to Flyer
