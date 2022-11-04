//
//  SkeletonView.swift
//  Volume
//
//  Created by Daniel Vebman on 12/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SkeletonView: View {
    @State private var animate = false

    private var animation: Animation {
        Animation
            .easeInOut(duration: Constants.duration)
            .repeatForever(autoreverses: true)
    }

    var body: some View {
        Rectangle()
            .fill(Color.volume.veryLightGray)
            .opacity(animate ? Constants.minOpacity : Constants.maxOpacity)
            .transition(.opacity)
            .onAppear {
                withAnimation(animation) {
                    animate.toggle()
                }
            }
    }
}

extension SkeletonView {
    private struct Constants {
        static let minOpacity = 0.25
        static let maxOpacity = 1.0
        static let duration = 1.0
    }
}
