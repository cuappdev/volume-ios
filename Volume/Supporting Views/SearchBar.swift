//
//  SearchBar.swift
//  Volume
//
//  Created by Vian Nguyen on 11/25/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.isEnabled) private var searchEnabled
    @EnvironmentObject private var userData: UserData
    @Binding var searchState: SearchView.SearchState
    @Binding var searchText: String
    @FocusState var showingCursor: Bool
    
    private var hasSearchText: Bool {
        !searchText.isEmpty
    }
    
    private struct Constants {
        static let animationDuration: CGFloat = 0.1
        static let searchBarDefaultText: String = "Search"
        static let searchBarDefaultTextSize: CGFloat = 16
        static let searchBarCornerRadiusSize: CGFloat = 5
        static let searchBarPaddingSize: CGFloat = 10
        static let searchBarShadowRadiusSize: CGFloat = 4
        static let searchIconFrameWidth: CGFloat = 15
        static let searchIconFrameHeight: CGFloat = 15
        static let sectionHorizontalPadding: CGFloat = 17
    }
    
    var body: some View {
        if searchEnabled {
            HStack {
                searchTextField
                
                Spacer()
                    .frame(width: Constants.sectionHorizontalPadding)
                
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } else {
            searchTextField
        }
    }
    
    private var searchTextField: some View {
        HStack {
            Image.volume.searchIcon
                .aspectRatio(contentMode: .fill)
                .frame(width: Constants.searchIconFrameWidth,
                       height: Constants.searchIconFrameHeight)
            
            TextField(Constants.searchBarDefaultText, text: $searchText)
                .font(.helveticaRegular(size: Constants.searchBarDefaultTextSize))
                .focused($showingCursor)
                .multilineTextAlignment(.leading)
                .onChange(of: showingCursor) { _ in
                    searchState = showingCursor ? .searching : searchState
                }
                .onChange(of: searchState) { _ in
                    showingCursor = searchState == .searching
                }
                .onSubmit {
                    if hasSearchText {
                        userData.updateRecentSearchQueries(searchText)
                        showingCursor = false
                        searchState = .results
                    }
                }
            
            if hasSearchText {
                Image.volume.xIcon
                    .onTapGesture {
                        searchText = ""
                    }
            }
        }
        .padding(Constants.searchBarPaddingSize)
        .background(
            RoundedRectangle(cornerRadius: Constants.searchBarCornerRadiusSize)
                .fill(Color.volume.gbackgroundGray)
        )
        .frame(alignment: .leading)
        .shadow(color: Color.volume.shadowBlack,
                radius: Constants.searchBarShadowRadiusSize)
        .onAppear {
            showingCursor = searchState == .searching
        }
    }
    
}
