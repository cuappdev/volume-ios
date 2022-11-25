//
//  SearchBar.swift
//  Volume
//
//  Created by Vian Nguyen on 11/25/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText: String = ""
    
    private struct Constants {
        static let searchBarDefaultText: String = "Search"
        static let searchBarDefaultTextSize: CGFloat = 16
        static let searchBarCornerRadiusSize: CGFloat = 5
        static let searchBarPaddingSize: CGFloat = 10
        static let searchBarShadowRadiusSize: CGFloat = 4
        static let searchIconFrameWidth: CGFloat = 15
        static let searchIconFrameHeight: CGFloat = 15
    }
    
    var body: some View {
        HStack {
            Image.volume.searchIcon
                .aspectRatio(contentMode: .fill)
                .frame(width: Constants.searchIconFrameWidth,
                       height: Constants.searchIconFrameHeight)
                
            TextField(Constants.searchBarDefaultText, text: $searchText)
                .font(.helveticaRegular(size: Constants.searchBarDefaultTextSize))
                .onSubmit {
                    searchSubmit()
                }
        }
        .padding(Constants.searchBarPaddingSize)
        .background(
            RoundedRectangle(cornerRadius: Constants.searchBarCornerRadiusSize)
                .fill(Color.volume.backgroundGray)
        )
        .shadow(color: Color.volume.shadowBlack,
                radius: Constants.searchBarShadowRadiusSize)
        
    }
    
    private func searchSubmit() {
        print("PRESSED SEARCH")
    }
    
}
