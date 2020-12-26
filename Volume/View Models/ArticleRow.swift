//
//  ArticleRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI

struct ArticleRow: View {
    let article: Article
        
    var body: some View {
        HStack(spacing: 20) {
            ArticleInfo(article: article)
            
            if let url = article.imageURL {
                WebImage(url: url)
                    .resizable()
                    .grayBackground()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            }
        }
        .frame(maxWidth: .infinity, idealHeight: 100, alignment: .leading)
    }
}

extension ArticleRow {
    struct Skeleton: View {
        var body: some View {
            HStack(spacing: 20) {
                ArticleInfo.Skeleton()
                SkeletonView()
                    .frame(width: 100, height: 100)
            }
            .frame(maxWidth: .infinity, idealHeight: 100, alignment: .leading)
        }
    }
}

//struct ArticleRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ArticleRow(
//            article: Article(
//                articleURL: nil,
//                date: Date(),
//                id: "a",
//                imageURL: nil,
//                publication: Publication(
//                    description: "CU",
//                    name: "CUNooz",
//                    id: "sdfsdf",
//                    imageURL: nil,
//                    recent: "Sandpaper Tastes Like What?!"
//                ),
//                shoutOuts: 14,
//                title: "Children Discover the Meaning of Christmas"
//            )
//        )
//    }
//}
