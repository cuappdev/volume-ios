//
//  HomeList.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct HomeList: View {
    private let spacing: CGFloat = 24.0
            
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                Header(text: "The Big Read")
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: spacing) {
                        ForEach(Array(Set(articleData)).shuffled()) { article in
                            BigReadArticleRow(article: article)
                        }
                    }
                }
                .padding([.bottom, .leading, .trailing])
                
                Header(text: "Following")
                ForEach (articleData.shuffled()) { article in
                    ArticleRow(article: article)
                        .padding([.bottom, .leading, .trailing])
                }
                
                VolumeMessage(message: .upToDate)
                    .padding([.top, .bottom], 25)
                
                Header(text: "Other Articles")
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
