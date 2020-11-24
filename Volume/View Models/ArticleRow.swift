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
            
            if let image = article.image {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            }
        }
        .frame(maxWidth: .infinity, idealHeight: 100, alignment: .leading)
    }
}

struct ArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRow(article: articleData[0])
    }
}
