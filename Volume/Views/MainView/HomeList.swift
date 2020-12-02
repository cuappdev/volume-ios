//
//  HomeList.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct HomeList: View {
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    Header("The Big Read")
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 24) {
                            ForEach(articleData[0..<1]) { article in
                                BigReadArticleRow(article: article)
                            }
                        }
                    }
                    .padding([.bottom, .leading, .trailing])

                    Header("Following")
                    ForEach(articleData[1..<2]) { article in
                        ArticleRow(article: article)
                            .padding([.bottom, .leading, .trailing])
                    }
                    
                    VolumeMessage(message: .upToDate)
                        .padding([.top, .bottom], 25)
                    
                    Header("Other Articles")
                    ForEach(articleData[2..<3]) { article in
                        ArticleRow(article: article)
                            .padding([.bottom, .leading, .trailing])
                    }
                }
            }
            .background(Color.volume.backgroundGray)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Image("volume-logo")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HomeList_Previews: PreviewProvider {
    static var previews: some View {
        HomeList()
    }
}
