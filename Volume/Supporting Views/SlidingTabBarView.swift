//
//  SlidingTabBarView.swift
//  Volume
//
//  Created by Hanzheng Li on 11/18/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SlidingTabBarView<T: Hashable>: View {

    @Namespace var namespace

    @Binding var selectedTab: T
    let items: [Item]

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
        .padding(.horizontal)
    }

    private func tab(for item: Item) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Text(item.title)
                .font(.newYorkMedium(size: 18))
                .foregroundColor(selectedTab == item.tab ? Color.volume.orange : .black)
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
