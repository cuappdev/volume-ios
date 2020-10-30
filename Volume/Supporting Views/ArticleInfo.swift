//
//  ArticleInfo.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ArticleInfo: View {
    
    var article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.publication)
                .font(.system(size: 12, weight: .medium))
            Text(article.title)
                .lineLimit(3)
                .font(.system(size: 18, weight: .bold))
            Spacer()
            Text("\(article.date) · \(article.read_duration) min read")
                .font(.system(size: 10))
                .foregroundColor(Color(white: 79/255, opacity: 1.0))
        }
    }
    
}

struct ArticleInfo_Previews: PreviewProvider {
    static var previews: some View {
        ArticleInfo(article: articleData[0])
    }
}
