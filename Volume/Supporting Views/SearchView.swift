//
//  SearchView.swift
//  Volume
//
//  Created by Vian Nguyen on 11/25/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchState: SearchState = .searching
    
    private struct Constants {
        static let sectionHorizontalPadding: CGFloat = 19
        static let sectionVerticalPadding: CGFloat = 18
    }
    
    var body: some View {
        ZStack {
            Color.volume.backgroundGray.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 0) {
                SearchBar(searchState: $searchState, searchText: $searchText)
                
                Spacer()
                    .frame(height: Constants.sectionVerticalPadding)
                
                switch searchState {
                case .searching:
                    SearchDropdownView(searchState: $searchState, searchText: $searchText)
                case .results:
                    SearchResultsList(searchText: searchText)
                        .transition(.move(edge: .trailing))
                }
            }
            .foregroundColor(.black)
            .padding(EdgeInsets(top: Constants.sectionVerticalPadding, leading: Constants.sectionHorizontalPadding, bottom: 0, trailing: Constants.sectionHorizontalPadding))
        }
        .hiddenNavigationBarStyle()
    }
    
}

extension SearchView {
    enum SearchState {
        case searching, results
    }

}


