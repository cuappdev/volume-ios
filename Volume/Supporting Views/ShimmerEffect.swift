//
//  ShimmerEffect.swift
//  Volume
//
//  Created by Vin Bui on 3/23/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension View {

    @ViewBuilder
    func shimmer(_ config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffect(config: config))
    }

}

struct ShimmerEffect: ViewModifier {

    @State private var moveTo: CGFloat = -1.5
    var config: ShimmerConfig

    func body(content: Content) -> some View {
        content
            .hidden()
            .overlay {
                Rectangle()
                    .fill(config.tint)
                    .mask {
                        content
                    }
                    .overlay {
                        GeometryReader {
                            let size = $0.size
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    Rectangle()
                                        .fill(
                                            .linearGradient(colors: [
                                                .white.opacity(0),
                                                config.highlight.opacity(config.highlightOpacity),
                                                .white.opacity(0)
                                            ], startPoint: .top, endPoint: .bottom)
                                        )
                                        .frame(width: 100)
                                        .blur(radius: config.blur)
                                        .rotationEffect(.init(degrees: config.degrees))
                                        .offset(x: size.width * moveTo)
                                }
                        }
                        .mask {
                            content
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 1.5
                        }
                    }
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }

}

struct ShimmerConfig {
    
    // MARK: - Design Constants
    var tint: Color
    var highlight: Color
    var blur: CGFloat
    var highlightOpacity: CGFloat = 1
    var speed: CGFloat = 1
    var degrees: CGFloat = -70

}

extension ShimmerConfig {
    
    // MARK: - Shimmer Presets
    
    static func smallShimmer() -> ShimmerConfig {
        return ShimmerConfig(
            tint: Color.gray.opacity(0.3),
            highlight: Color.white,
            blur: 30,
            speed: 1.5,
            degrees: -70
        )
    }
    
    static func mediumShimmer() -> ShimmerConfig {
        return ShimmerConfig(
            tint: Color.gray.opacity(0.3),
            highlight: Color.white,
            blur: 33,
            speed: 1.5,
            degrees: -70
        )
    }
    
    static func largeShimmer() -> ShimmerConfig {
        return ShimmerConfig(
            tint: Color.gray.opacity(0.3),
            highlight: Color.white.opacity(0.85),
            blur: 35,
            speed: 1.3,
            degrees: 12
        )
    }
    
}
