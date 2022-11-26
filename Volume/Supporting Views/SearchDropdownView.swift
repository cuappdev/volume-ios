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
    var suggestedSearchQueries = ["query1", "query2", "query3", "query4", "query5"]
    
    struct Constants {
        static let searchQueryTextPadding: CGFloat = 25
        static let searchQueryTextSize: CGFloat = 16
        static let sectionHorizontalPadding: CGFloat = 19
        static let sectionVerticalPadding: CGFloat = 18
        static let suggestedSearchHeader: String = "Recent Searches"
        
    }
    
    var body: some View {
        ZStack {
            Color.volume.backgroundGray.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: Constants.sectionVerticalPadding) {
                
                SearchBar(searchEnabled: true)
                
                Header(Constants.suggestedSearchHeader)
                
                searchQueries
                
                Spacer()
            }
            .foregroundColor(.black)
            .padding(EdgeInsets(top: Constants.sectionVerticalPadding, leading: Constants.sectionHorizontalPadding, bottom: Constants.sectionVerticalPadding, trailing: Constants.sectionHorizontalPadding))

        }
        
    }
    
    private var searchQueries: some View {
        VStack(spacing: Constants.searchQueryTextPadding) {
            ForEach(suggestedSearchQueries, id: \.self) { query in
                NavigationLink {
                    
                } label: {
                    Text(query)
                        .font(.helveticaNeueMedium(size: Constants.searchQueryTextSize))
                }
            }
        }
    }
    
}
