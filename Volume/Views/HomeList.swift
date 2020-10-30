//
//  HomeList.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct HomeList: View {
    
    private var spacing: CGFloat = 20.0
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                Text("THE BIG READ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .bottom])
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacing) {
                        ForEach (articleData) { article in
                            BigReadArticleRow(article: article)
                        }
                    }
                    .padding([.bottom, .leading, .trailing])
                }
                
                VStack(spacing: spacing) {
                    Text("FOLLOWING")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach (articleData) { article in
                        ArticleRow(article: article)
                    }
                    
                    UpToDateView()
                        .padding([.top, .bottom], 25)
                    
                    Text("OTHER ARTICLES")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach (articleData) { article in
                        ArticleRow(article: article)
                    }
                }
                .padding([.leading, .trailing])
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom)
            .navigationTitle("Volume.")
        }
    }
}

struct HomeList_Previews: PreviewProvider {
    static var previews: some View {
        HomeList()
    }
}
