//
//  EmptyButtonStyle.swift
//  Volume
//
//  Created by Vin Bui on 4/6/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// `ButtonStyle` that removes highlighting when tapped. Can be used on `NavigationLink` to remove highlighting.
struct EmptyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}
