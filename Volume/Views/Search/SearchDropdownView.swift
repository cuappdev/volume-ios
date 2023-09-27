//
//  SearchDropdownView.swift
//  Volume
//
//  Created by Vian Nguyen on 11/25/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SearchDropdownView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var searchState: SearchView.SearchState
    @Binding var searchText: String
    @EnvironmentObject private var userData: UserData
    
    private var suggestedSearchQueries: [String] {
        userData.recentSearchQueries
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let animationDuration: CGFloat = 0.1
        static let searchQueryTextPadding: CGFloat = 25
        static let searchQueryTextSize: CGFloat = 16
        static let suggestedSearchHeader: String = "Recent Searches"
    }
    
    // MARK: - UI
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                suggestedSearchQueries.count > 0 ? Header(Constants.suggestedSearchHeader) : nil
                
                Group {
                    ForEach(suggestedSearchQueries, id: \.self) { query in
                        searchRow(query)
                    }
                }
                .padding(.bottom, Constants.searchQueryTextPadding)
            }
            
            Spacer()
        }
    }
    
    private func searchRow(_ query: String) -> some View {
        HStack {
            Text(query)
                .font(.helveticaNeueMedium(size: Constants.searchQueryTextSize))
                .onTapGesture {
                    withAnimation(.linear(duration: Constants.animationDuration)) {
                        userData.addRecentSearchQueries(query)
                        searchText = query
                        searchState = .results
                    }
                }
            
            Spacer()
            
            Text("✗")
                .onTapGesture {
                    withAnimation(.linear(duration: Constants.animationDuration)) {
                        userData.removeRecentSearchQueries(query)
                    }
                }
        }
    }
    
}
