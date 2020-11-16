//
//  BigReadArticleRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct BigReadArticleRow: View {
    let article: Article
    
    var body: some View {
        VStack(spacing: 15) {
            if article.image != nil {
                Image(article.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
                    .clipped()
                    .padding(.bottom, 4)
            } else {
                Rectangle() // TODO: Custom image displaying beginning of article in large font
                    .frame(width: 180, height: 180)
                    .foregroundColor(.blue)
            }
            ArticleInfo(article: article)
        }
        .frame(width: 180, height: 300)
    }
}

struct BigReadArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        BigReadArticleRow(article: articleData[0])
    }
}
