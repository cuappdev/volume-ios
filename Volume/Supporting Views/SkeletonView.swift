//
//  SkeletonView.swift
//  Volume
//
//  Created by Daniel Vebman on 12/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SkeletonView: View {
    var body: some View {
        Rectangle()
            .fill(Color.volume.veryLightGray)
            .transition(.opacity)
    }
}
