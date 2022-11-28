//
//  Image+Extensions.swift
//  Volume
//
//  Created by Hanzheng Li on 3/5/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension Image {
    static let volume = Volume()
    
    // Add new image assets to this set of constants
    struct Volume {
        // socials not included b/c names are specified by backend strings
        let backArrow = Image("back-arrow")
        let bookmark = Image("bookmark")
        let compass = Image("compass")
        let feed = Image("feed")
        let flag = Image("flag")
        let follow = Image("follow")
        let followed = Image("followed")
        let info = Image("info")
        let leftArrow = Image("left-arrow")
        let logo = Image("volume-logo")
        let magazine = Image("magazine")
        let menu = Image("menu")
        let noConnection = Image("no-connection")
        let pen = Image("pen")
        let period = Image("period")
        let rightArrow = Image("right-arrow")
        let searchIcon = Image("search-icon")
        let settings = Image("settings")
        let share = Image("share")
        let shared = Image("shared")
        let shoutout = Image("shout-out")
        let underline = Image("underline")
        let weeklyDebriefCurves = Image("weekly-debrief-curves")
        let xIcon = Image("x-icon")
    }
}
