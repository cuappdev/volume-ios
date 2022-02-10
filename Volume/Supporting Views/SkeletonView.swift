//
//  SkeletonView.swift
//  Volume
//
//  Created by Daniel Vebman on 12/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SkeletonView: View {
    private let maxOpacity = 1.0
    private let duration = 0.9
    @State private var opacity = 0.25
    
    var body: some View {
        Rectangle()
            .fill(Color.volume.veryLightGray)
            .opacity(opacity)
            .transition(.opacity)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: duration)
                let repeated = baseAnimation.repeatForever(autoreverses: true)
                withAnimation(repeated) {
                    self.opacity = maxOpacity
                }
            }
    }
}
