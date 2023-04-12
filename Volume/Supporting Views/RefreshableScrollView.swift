//
//  RefreshableScrollView.swift
//  Volume
//
//  Created by Cameron Russell on 3/29/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

// NOTE: Once SwiftUI provides functionality similar to UIKit's RefreshControl, this file
// should be deleted. Documentation for the code can be found at the below source. Only
// slight modifications have been made.
// source: https://swiftuirecipes.com/blog/pull-to-refresh-with-swiftui-scrollview

import SwiftUI


private enum PositionType {
    case fixed, moving
}

private struct Position: Equatable {
    let type: PositionType
    let y: CGFloat
}

private struct PositionPreferenceKey: PreferenceKey {
    typealias Value = [Position]

    static var defaultValue = [Position]()

    static func reduce(value: inout [Position], nextValue: () -> [Position]) {
        value.append(contentsOf: nextValue())
    }
}

private struct PositionIndicator: View {
    let type: PositionType

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: PositionPreferenceKey.self,
                    value: [Position(type: type, y: proxy.frame(in: .global).minY)]
                )
        }
    }
}

struct RefreshableScrollView<Content: View>: View {
    typealias RefreshComplete = () -> Void
    typealias OnRefresh = (@escaping RefreshComplete) -> Void

    @State private var state = RefreshState.waiting // the current state
    private let threshold: CGFloat = 50
    
    let content: Content
    let onRefresh: OnRefresh

    private enum RefreshState {
      case waiting, primed, loading
    }
    
    init(onRefresh: @escaping OnRefresh, @ViewBuilder content: () -> Content) {
        self.onRefresh = onRefresh
        self.content = content()
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .top) {
                PositionIndicator(type: .moving)
                    .frame(height: 0)

                content
                    .alignmentGuide(.top) { _ in
                        (state == .loading) ? -threshold : 0
                    }

                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: threshold)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                .offset(y: (state == .loading) ? 0 : -threshold)
            }
        }
        .background(PositionIndicator(type: .fixed))
        .onPreferenceChange(PositionPreferenceKey.self) { values in
            if state != .loading {
                DispatchQueue.main.async {
                    let movingY = values.first { $0.type == .moving }?.y ?? 0
                    let fixedY = values.first { $0.type == .fixed }?.y ?? 0
                    let offset = movingY - fixedY

                    if offset > threshold && state == .waiting {
                        Haptics.shared.play(.light)
                        state = .primed
                    } else if offset < threshold && state == .primed {
                        state = .loading
                        onRefresh {
                            withAnimation {
                                self.state = .waiting
                            }
                        }
                    }
                }
            }
        }
    }
}
