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
    @Binding var searchState: SearchView.SearchState
    @Binding var searchText: String
    var suggestedSearchQueries = ["guac", "hi", "hola", "yes", "hihi"]
    
    private struct Constants {
        static let animationDuration: CGFloat = 0.1
        static let searchQueryTextPadding: CGFloat = 25
        static let searchQueryTextSize: CGFloat = 16
        static let suggestedSearchHeader: String = "Recent Searches"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Header(Constants.suggestedSearchHeader)
            VStack(alignment: .leading, spacing: Constants.searchQueryTextPadding) {
                ForEach(suggestedSearchQueries, id: \.self) { query in
                    Text(query)
                        .font(.helveticaNeueMedium(size: Constants.searchQueryTextSize))
                        .onTapGesture {
                            withAnimation(.linear(duration: Constants.animationDuration)) {
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
