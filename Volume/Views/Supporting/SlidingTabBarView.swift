//
//  SlidingTabBarView.swift
//  Volume
//
//  Created by Hanzheng Li on 11/18/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SlidingTabBarView<T: Hashable>: View {

    // MARK: - Properties

    @Namespace var namespace
    @Binding var selectedTab: T

    let items: [Item]

    var addSidePadding: Bool = true
    var font: Font = .newYorkMedium(size: 18)
    var selectedColor: Color = Color.volume.orange
    var unselectedColor: Color = Color.black

    // MARK: - UI

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.tab) { item in
                if let width = item.width {
                    tab(for: item)
                        .frame(width: width)
                } else {
                    tab(for: item)
                }
            }

            Spacer()
        }
        .padding(.horizontal, addSidePadding ? 16 : 0)
    }

    private func tab(for item: Item) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Text(item.title)
                .font(font)
                .foregroundColor(selectedTab == item.tab ? selectedColor : unselectedColor)
                .padding(.top)

            if selectedTab == item.tab {
                Color.volume.orange
                    .frame(height: 2)
                    .matchedGeometryEffect(
                        id: "underline",
                        in: namespace,
                        properties: .frame
                    )
            } else {
                Color.volume.veryLightGray
                    .frame(height: 2)
            }
        }
        .animation(.spring(), value: selectedTab)
        .onTapGesture {
            selectedTab = item.tab
        }
    }

}

extension SlidingTabBarView {

    struct Item {
        let title: String
        let tab: T
        let width: CGFloat?

        init(title: String, tab: T, width: CGFloat? = nil) {
            self.title = title
            self.tab = tab
            self.width = width
        }
    }

}
