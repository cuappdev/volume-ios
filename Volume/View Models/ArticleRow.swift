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
    let navigationSource: NavigationSource
    let showsPublicationName: Bool

    init(article: Article, navigationSource: NavigationSource, showsPublicationName: Bool = true) {
        self.article = article
        self.navigationSource = navigationSource
        self.showsPublicationName = showsPublicationName
    }

    var body: some View {
        NavigationLink(destination: BrowserView(initType: .readyForDisplay(article), navigationSource: navigationSource)) {
            HStack(spacing: 20) {
                ArticleInfo(article: article, showsPublicationName: showsPublicationName)

                if let url = article.imageUrl {
                    WebImage(url: url)
                        .resizable()
                        .grayBackground()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: showsPublicationName ? 100 : 80, height: showsPublicationName ? 100 : 80)
                        .clipped()
                }
            }
            .frame(maxWidth: .infinity, idealHeight: showsPublicationName ? 100 : 80, alignment: .leading)
        }
        .accentColor(Color.black)
    }
}

extension ArticleRow {
    struct Skeleton: View {
        let showsPublicationName: Bool

        init(showsPublicationName: Bool = true) {
            self.showsPublicationName = showsPublicationName
        }

        var body: some View {
            HStack(spacing: 20) {
                ArticleInfo.Skeleton(showsPublicationName: showsPublicationName)
                SkeletonView()
                    .frame(width: showsPublicationName ? 100 : 80, height: showsPublicationName ? 100 : 80)
            }
            .frame(maxWidth: .infinity, idealHeight: showsPublicationName ? 100 : 80, alignment: .leading)
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
