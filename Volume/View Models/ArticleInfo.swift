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
    let showsPublicationName: Bool
    let isDebrief: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                if showsPublicationName {
                    Text(article.publication.name)
                        .font(.newYorkMedium(size: isDebrief ? 18 : 12))
                        .padding(.bottom, isDebrief ? 3.5 : 1.5)
                        .multilineTextAlignment(.leading)
                }

                Text(article.title)
                    .font(.helveticaNeueMedium(size: isDebrief ? 24 : 16))
                    .lineLimit(3)
                    .padding(.top, 0.5)
                    .multilineTextAlignment(.leading)

                Spacer()

                HStack(alignment: .firstTextBaseline) {
                    // swiftlint:disable:next line_length
                    Text("\(article.date.fullString) • \(max(article.shoutouts, userData.shoutoutsCache[article.id, default: 0])) shout-outs")
                        .font(.helveticaRegular(size: isDebrief ? 14 : 10) )
                        .foregroundColor(.volume.lightGray)
                    if userData.isArticleSaved(article) {
                        Image.volume.bookmark
                            .resizable()
                            .foregroundColor(.volume.orange)
                            .frame(width: isDebrief ? 9 : 8, height: isDebrief ? 12 : 11)
                    }
                }
            }
            Spacer()
        }
    }
}

extension ArticleInfo {
    struct Skeleton: View {
        let showsPublicationName: Bool
        let isDebrief: Bool

        init(showsPublicationName: Bool = true, isDebrief: Bool = false) {
            self.showsPublicationName = showsPublicationName
            self.isDebrief = isDebrief
        }

        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    if showsPublicationName {
                        SkeletonView()
                            .frame(width: 70, height: isDebrief ? 23 : 14)
                            .padding(.bottom, isDebrief ? 4 : 3)
                    }

                    SkeletonView()
                        .frame(height: isDebrief ? 90 : 40)

                    Spacer()

                    HStack(alignment: .firstTextBaseline) {
                        SkeletonView()
                            .frame(width: 33, height: isDebrief ? 14 : 10)
                        Text(" • ")
                            .font(.helveticaRegular(size: 10))
                            .foregroundColor(.volume.veryLightGray)
                        SkeletonView()
                            .frame(width: 70, height: isDebrief ? 14 : 10)
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
