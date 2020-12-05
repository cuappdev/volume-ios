//
//  ArticleInfo.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ArticleInfo: View {
    let article: Article
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(article.publication)
                    .font(.begumMedium(size: 12))
                Text(article.title)
                    .font(.helveticaBold(size: 16))
                    .lineLimit(3)
                    .padding(.top, 0.5)
                Spacer()
                HStack {
                    Text("\(article.date.string) • \(article.shoutOuts) shout-outs")
                        .font(.helveticaRegular(size: 10))
                        .foregroundColor(Color.volume.lightGray)
                    if article.isSaved {
                        Image(systemName: "bookmark.fill")
                            .resizable()
                            .foregroundColor(Color.volume.orange)
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
