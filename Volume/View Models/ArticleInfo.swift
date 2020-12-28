//
//  ArticleInfo.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ArticleInfo: View {
    @EnvironmentObject private var userData: UserData
    
    let article: Article
    let showsPublicationName = true
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if showsPublicationName {
                    Text(article.publication)
                        .font(.begumMedium(size: 12))
                }

                Text(article.title)
                    .font(.helveticaBold(size: 16))
                    .lineLimit(3)
                    .padding(.top, 0.5)
                Spacer()
                HStack {
                    Text("\(article.date.string) • \(article.shoutOuts) shout-outs")
                        .font(.helveticaRegular(size: 10))
                        .foregroundColor(Color.volume.lightGray)
                    if userData.isArticleSaved(article) {
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

extension ArticleInfo {
    struct Skeleton: View {
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    SkeletonView()
                        .frame(width: 70, height: 14)
                    SkeletonView()
                        .frame(height: 40)
                    Spacer()
                    HStack(spacing: 0) {
                        SkeletonView()
                            .frame(width: 33, height: 10)
                        Text(" • ")
                            .font(.helveticaRegular(size: 10))
                            .foregroundColor(Color.volume.lightGray)
                        SkeletonView()
                            .frame(width: 70, height: 10)
                    }
                }
                Spacer()
            }
        }
    }
}

//struct ArticleInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        ArticleInfo(
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
