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
        /// The color used as the background for buttons.
        let buttonGray = Color(white: 238 / 255)
        let lightGray = Color(white: 153 / 255)
        /// The color used for SkeletonViews
        let veryLightGray = Color(white: 230 / 255)
        let orange = Color(red: 208 / 255, green: 112 / 255, blue: 0 / 255)
        let lightOrange = Color(red: 255 / 255, green: 239 / 255, blue: 220 / 255)
        let shadowBlack = Color(white: 10 / 255, opacity: 0.10)
    }
}
