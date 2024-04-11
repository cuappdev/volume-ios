//
//  ContentFilterBarView.swift
//  Volume
//
//  Created by Vian Nguyen on 4/15/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ContentFilterBarView: View {
    @Binding var selectedTab: FilterContentType
    var showArticleTab: Bool = true
    var showMagazineTab: Bool = true
    var showFlyerTab: Bool = true

    var body: some View {
        SlidingTabBarView(
            selectedTab: $selectedTab,
            items: [
                showArticleTab ? SlidingTabBarView.Item(
                    title: "Articles",
                    tab: .articles,
                    width: Constants.articlesTabWidth
                ) : nil,
                showMagazineTab ? SlidingTabBarView.Item(
                    title: "Magazines",
                    tab: .magazines,
                    width: Constants.magazinesTabWidth
                ) : nil,
                showFlyerTab ? SlidingTabBarView.Item(
                    title: "Flyers",
                    tab: .flyers,
                    width: Constants.flyersTabWidth
                ) : nil
            ].compactMap { $0 }
        )
    }

    private struct Constants {
        static let articlesTabWidth: CGFloat = 80
        static let flyersTabWidth: CGFloat = 70
        static let magazinesTabWidth: CGFloat = 110
    }
}
