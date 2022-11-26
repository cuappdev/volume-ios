//
//  SearchRootView.swift
//  Volume
//
//  Created by Vian Nguyen on 11/25/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SearchRootView: View {
    var hasSearchResults = false
    var searchQuery = ""
    
    private struct Constants {
        static let sectionHorizontalPadding: CGFloat = 19
        static let sectionVerticalPadding: CGFloat = 18
    }
    
    var body: some View {
        ZStack {
            Color.volume.backgroundGray.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: Constants.sectionVerticalPadding) {
                
                SearchBar(searchEnabled: true)
                
                if hasSearchResults {
                    SearchQueryResultsView(searchQuery: searchQuery)
                } else {
                    SearchDropdownView()
                }
                
                Spacer()
            }
            .foregroundColor(.black)
            .padding(EdgeInsets(top: Constants.sectionVerticalPadding, leading: Constants.sectionHorizontalPadding, bottom: Constants.sectionVerticalPadding, trailing: Constants.sectionHorizontalPadding))
        }
        .hiddenNavigationBarStyle()
    }
    
}


