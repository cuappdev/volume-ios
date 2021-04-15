//
//  VolumeInfo.swift
//  Volume
//
//  Created by Cameron Russell on 4/15/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct Metadata {
    static var aboutUs: AboutUs {
        let filepath = Bundle.main.url(forResource: "AboutUs", withExtension: "json")!
        let data = try! Data(contentsOf: filepath)
        let result = try! JSONDecoder().decode(AboutUs.self, from: data)
        return result
    }
}

struct AboutUs: Codable {
    var messages: Messages
    var subteams: [String: [String]]
}

struct Messages: Codable {
    var ourMission: String
    var teamInfo: String
}
