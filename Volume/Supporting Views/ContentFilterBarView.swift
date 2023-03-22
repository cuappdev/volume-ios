//
//  ContentFilterBarView.swift
//  Volume
//
//  Created by Vian Nguyen on 3/22/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ContentFilterBarView: View {
    
    @Binding var selectedTab: Publication.ContentType
    var showArticleTab: Bool = true
    var showMagazineTab: Bool = true
    
    var body: some View {
        SlidingTabBarView(
            selectedTab: $selectedTab,
            items: [
                showArticleTab ? SlidingTabBarView.Item(
                    title: "Articles",
                    tab: .articles,
                    width: Constants.articleTabWidth
                ) : nil,
                showMagazineTab ? SlidingTabBarView.Item(
                    title: "Magazines",
                    tab: .magazines,
                    width: Constants.magazineTabWidth
                ) : nil
            ].compactMap { $0 }
        )
    }
    
    private struct Constants {
        static let articleTabWidth: CGFloat = 80
        static let magazineTabWidth: CGFloat = 106
        
    }
    
}



