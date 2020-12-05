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
        GeometryReader { geometry in
            NavigationView {
                ScrollView(showsIndicators: false) {
                    Header("Saved Articles").padding(.bottom, -12)
                    if let savedArticles = articleData.filter{ $0.isSaved }[0..<1],
                       savedArticles.count > 0 {
                        LazyVStack {
                            ForEach (savedArticles) { article in
                                ArticleRow(article: article)
                                    .padding([.bottom, .leading, .trailing])
                            }
                        }
                    } else {
                        VStack {
                            Spacer(minLength: geometry.size.height / 5)
                            VolumeMessage(message: .noBookmarks)
                        }
                    }
                }
                .background(Color.volume.backgroundGray)
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        BubblePeriodText("Bookmarks")
                            .font(.begumMedium(size: 28))
                            .offset(y: 8)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct BookmarksList_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksList()
    }
}
