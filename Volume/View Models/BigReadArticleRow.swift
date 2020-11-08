//
//  BigReadArticleRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct BigReadArticleRow: View {
    
    var article: Article
    
    var body: some View {
        VStack(spacing: 15) {
            Image(article.image!) // TODO: change
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 180)
                .clipped()
            ArticleInfo(article: article)
                .padding(.top, 4)
        }
        .frame(width: 180, height: 330)
    }
}

//struct BigReadArticleRow_Previews: PreviewProvider {
//    static var previews: some View {
//        BigReadArticleRow()
//    }
//}
