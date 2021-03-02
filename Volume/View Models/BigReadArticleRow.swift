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
        NavigationLink(destination: BrowserView(article: article)) {
            VStack(spacing: 16) {
                if let url = article.imageUrl {
                    WebImage(url: url)
                        .resizable()
                        .grayBackground()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 180)
                        .clipped()
                } else {
                    WebImage(url: article.publication.profileImageUrl)
                        .resizable()
                        .grayBackground()
                        .frame(width: 120, height: 120)
                        .padding(30)
                }
                ArticleInfo(article: article, showsPublicationName: true)
            }
            .frame(width: 180, height: 300)
        }
        .accentColor(Color.black)
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
