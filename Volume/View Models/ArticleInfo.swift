//
//  ArticleInfo.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ArticleInfo: View {
    private let lineLimit = 3

    let article: Article
    
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
                    Text("\(article.date.string) • \(article.shoutOuts) shout-outs")
                        .font(.custom("Helvetica-Regular", size: 10))
                        .foregroundColor(.lightGray)
                    if article.isSaved {
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
