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
        HStack {
            VStack(alignment: .leading) {
                Text(article.publication)
                    .font(.custom("Futura-Medium", size: 12)) // TODO: Begum
                Text(article.title)
                    .font(.custom("Helvetica-Bold", size: 16))
                    .lineLimit(lineLimit)
                    .padding(.top, 0.5)
                Spacer()
                HStack {
                    Text("\(article.date.string) • \(article.shout_outs) shout-outs")
                        .font(.custom("Helvetica-Regular", size: 10))
                        .foregroundColor(.lightGray)
                    if article.saved {
                        Image(systemName: "bookmark.fill")
                            .resizable()
                            .foregroundColor(.volumeOrange)
                            .frame(width: 8, height: 11)
                    }
                }
                
            }
            Spacer()
        }
    }
    
}

struct ArticleInfo_Previews: PreviewProvider {
    static var previews: some View {
        ArticleInfo(article: articleData[0])
    }
}
