//
//  ArticleRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ArticleRow: View {
    
    var article: Article
    
    var body: some View {
        HStack(spacing: 20) {
            Image(article.image!) // TODO: change
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipped()
            ArticleInfo(article: article)
        }
        .frame(height: 100)
    }
}

struct ArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRow(article: articleData[0])
    }
}
