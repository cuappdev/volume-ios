//
//  ArticleRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ArticleRow: View {
    let article: Article
        
    var body: some View {
        HStack(spacing: 20) {
            ArticleInfo(article: article)
            
            if article.image != nil {
                Image(article.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 110, height: 110)
                    .clipped()
            }
        }
        .frame(maxWidth: .infinity, idealHeight: 110, alignment: .leading)
    }
}

struct ArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRow(article: articleData[0])
    }
}
