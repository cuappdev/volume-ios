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

    var body: some View {
        ZStack {
            Color.volume.backgroundGray.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 0) {
                SearchBar(searchState: $searchState, searchText: $searchText)
                    .padding(.horizontal)

                switch searchState {
                case .searching:
                    SearchDropdownView(searchState: $searchState, searchText: $searchText)
                        .padding([.horizontal, .top])
                case .results:
                    SearchResultsList(searchText: searchText)
                        .transition(.move(edge: .trailing))
                }
            }
            .foregroundColor(.black)
        }
        .hiddenNavigationBarStyle()
    }

}

extension SearchView {

    enum SearchState {
        case searching, results
    }

}
