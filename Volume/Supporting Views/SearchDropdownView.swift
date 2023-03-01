//
//  SearchDropdownView.swift
//  Volume
//
//  Created by Vian Nguyen on 11/25/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SearchDropdownView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var userData: UserData
    @Binding var searchState: SearchView.SearchState
    @Binding var searchText: String
    
    private var suggestedSearchQueries: [String] {
        userData.recentSearchQueries
    }
    
    private struct Constants {
        static let animationDuration: CGFloat = 0.1
        static let searchQueryTextPadding: CGFloat = 25
        static let searchQueryTextSize: CGFloat = 16
        static let suggestedSearchHeader: String = "Recent Searches"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if suggestedSearchQueries.count > 0 {
                Header(Constants.suggestedSearchHeader)
            }
            VStack(alignment: .leading, spacing: Constants.searchQueryTextPadding) {
                ForEach(suggestedSearchQueries, id: \.self) { query in
                    Text(query)
                        .font(.helveticaNeueMedium(size: Constants.searchQueryTextSize))
                        .onTapGesture {
                            withAnimation(.linear(duration: Constants.animationDuration)) {
                                userData.addRecentSearchQueries(query)
                                searchText = query
                                searchState = .results
                            }
                        }
                }
            }
        }
        
        Spacer()
    }
    
}
