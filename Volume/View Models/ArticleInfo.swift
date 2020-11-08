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
    
    @State var lineLimit = 3
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.publication)
                .font(.custom("Futura-Medium", size: 12))
            Text(article.title)
                .lineLimit(lineLimit)
                .font(.custom("Helvetica-Bold", size: 18))
                .padding(.top, 0.5)
            Spacer()
            Text("\(article.date) · \(article.shout_outs) shout-outs")
                .font(.custom("Helvetica-Regular", size: 10))
                .foregroundColor(Color(white: 79/255, opacity: 1.0))
        }
    }
    
}

struct ArticleInfo_Previews: PreviewProvider {
    static var previews: some View {
        ArticleInfo(article: articleData[0])
    }
}
