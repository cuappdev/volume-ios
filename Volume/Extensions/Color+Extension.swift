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
        /// The color used in the navigation and tab bars. Renders as rgb=246.
        let navigationBarGray = Color(white: 250 / 255)
        /// The primary background color that matches the navigation/tab bars. Renders as rgb = 246.
        let backgroundGray = Color(white: 248 / 255)
        let lightGray = Color(white: 153 / 255)
        let orange = Color(red: 208 / 255, green: 112 / 255, blue: 0 / 255)
    }
}
