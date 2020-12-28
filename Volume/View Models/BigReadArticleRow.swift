//
//  BigReadArticleRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Combine
import SDWebImageSwiftUI
import SwiftUI

struct BigReadArticleRow: View {
    let article: Article
    
    var body: some View {
        VStack(spacing: 15) {
            if let url = article.imageURL {
                WebImage(url: url)
                    .resizable()
                    .grayBackground()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
                    .clipped()
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

extension BigReadArticleRow {
    struct Skeleton: View {
        var body: some View {
            VStack(spacing: 15) {
                SkeletonView()
                    .frame(width: 180, height: 180)
                ArticleInfo.Skeleton()
            }
            .frame(width: 180, height: 300)
        }
    }
}

//struct BigReadArticleRow_Previews: PreviewProvider {
//    static var previews: some View {
//        BigReadArticleRow(
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
