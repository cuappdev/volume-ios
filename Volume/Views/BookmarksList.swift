//
//  BookmarksList.swift
//  Volume
//
//  Created by Cameron Russell on 11/15/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct BookmarksList: View {
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                Header(text: "Saved Articles")
                ForEach (articleData.filter{ $0.saved }) { article in
                    ArticleRow(article: article)
                        .padding([.bottom, .leading, .trailing])
                }
            }
            .navigationTitle("Bookmarks.")
        }
    }
    
}

struct BookmarksList_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksList()
    }
}
