//
//  HomeList.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct HomeList: View {
    
    private var spacing: CGFloat = 24.0
            
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                Header(text: "THE BIG READ")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacing) {
                        ForEach (articleData.shuffled()) { article in
                            BigReadArticleRow(article: article)
                        }
                    }
                }
                .padding([.bottom, .leading, .trailing])
                
                Header(text: "FOLLOWING")
                ForEach (articleData.shuffled()) { article in
                    ArticleRow(article: article)
                        .padding([.bottom, .leading, .trailing])
                }
                
                UpToDate()
                    .padding([.top, .bottom], 25)
                
                Header(text: "OTHER ARTICLES")
                ForEach (articleData.shuffled()) { article in
                    ArticleRow(article: article)
                        .padding([.bottom, .leading, .trailing])
                }
            }
            .navigationTitle("Volume.")
        }
    }
    
}

struct HomeList_Previews: PreviewProvider {
    static var previews: some View {
        HomeList()
    }
}
