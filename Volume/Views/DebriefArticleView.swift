//
//  DebriefArticleView.swift
//  Volume
//
//  Created by Amy Chin Siu Huang on 12/2/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import SwiftUI
import SDWebImageSwiftUI

struct DebriefArticleView: View {
    @EnvironmentObject private var userData: UserData
    let header: String
//    let article: Article

    var body: some View {

        VStack {
            Header(header)
                .padding(.top, 24)
                .padding([.leading, .trailing], 75)
                .frame(alignment: .center)
//
//            Group {
//                NavigationLink(destination: BrowserView(initType: .readyForDisplay(article), navigationSource: .weeklyDebrief)) {
//                    VStack(spacing: 16) {
//                        if let url = article.imageUrl {
//                            WebImage(url: url)
//                                .resizable()
//                                .grayBackground()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 275, height: 275)
//                                .clipped()
//                        } else {
//                            WebImage(url: article.publication.profileImageUrl)
//                                .resizable()
//                                .grayBackground()
//                                .frame(width: 275, height: 275)
//                                .padding(30)
//                        }
//                        ArticleInfo(article: article, showsPublicationName: true)
//                    }
//                    .frame(width: 180, height: 300)
//                }
//                .accentColor(Color.black)
//            }


            HStack(spacing: 56) {
                Button {
//                    userData.toggleArticleSaved(article)
//                    AppDevAnalytics.log(
//                        userData.isArticleSaved(article) ?
//                        VolumeEvent.bookmarkArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief) :
//                            VolumeEvent.unbookmarkArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief)
//                    )
                } label: {
                    Image(systemName: "bookmark")
                        .foregroundColor(Color.volume.orange)
                }
                .frame(width: 44, height: 44)
                .overlay(Circle().stroke(Color.volume.orange, lineWidth: 4))
                .clipShape(Circle())

                Button {
//                    userData.toggleArticleSaved(article)
//                    AppDevAnalytics.log(
//                        userData.isArticleSaved(article) ?
//                        VolumeEvent.bookmarkArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief) :
//                            VolumeEvent.unbookmarkArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief)
//                    )
                } label: {
                    Image(systemName: "bookmark")
                        .foregroundColor(Color.volume.orange)
                }
                .frame(width: 44, height: 44)
                .overlay(Circle().stroke(Color.volume.orange, lineWidth: 4))
                .clipShape(Circle())

                Button {
//                    userData.toggleArticleSaved(article)
//                    AppDevAnalytics.log(
//                        userData.isArticleSaved(article) ?
//                        VolumeEvent.bookmarkArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief) :
//                            VolumeEvent.unbookmarkArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief)
//                    )
                } label: {
                    Image(systemName: "bookmark")
                        .foregroundColor(Color.volume.orange)
                }
                .frame(width: 44, height: 44)
                .overlay(Circle().stroke(Color.volume.orange, lineWidth: 4))
                .clipShape(Circle())
            }
            .padding([.leading, .trailing], 65)
        }
    }
}

//struct DebriefArticleView_Previews: PreviewProvider {
//    static var previews: some View {
//        DebriefArticleView()
//    }
//}
