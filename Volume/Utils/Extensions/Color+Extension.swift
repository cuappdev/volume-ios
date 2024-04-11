//
//  Color+ColorScheme.swift
//  Volume
//
//  Created by Cameron Russell on 10/28/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension Color {

    static let volume = Volume()

    struct Volume {
        let backgroundGray = Color(white: 245 / 255)
        let buttonGray = Color(white: 238 / 255)
        let buttonDisabledGray = Color(red: 244/255, green: 239/255, blue: 239/255)
        let errorRed = Color(red: 203/255, green: 46/255, blue: 46/255)
        let lightGray = Color(white: 153 / 255)
        let lightOrange = Color(red: 255 / 255, green: 239 / 255, blue: 220 / 255)
        let offWhite = Color(red: 248/255, green: 248/255, blue: 248/255)
        let orange = Color(red: 208 / 255, green: 112 / 255, blue: 0 / 255)
        let outlineGray = Color(red: 210 / 255, green: 210 / 255, blue: 210 / 255)
        let shadowBlack = Color(white: 10 / 255, opacity: 0.10)
        let textGray = Color(red: 88 / 255, green: 96 / 255, blue: 105 / 255)
        let transparentGray = Color(red: 238 / 255, green: 238 / 255, blue: 238 / 255)
        let veryLightGray = Color(white: 230 / 255)
    }

}
