//
//  Flyer.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

typealias FlyerID = String

// TODO: Reimplement once backend is finished

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
