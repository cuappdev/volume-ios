//
//  BrowserView.swift
//  Volume
//
//  Created by Daniel Vebman on 12/31/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI
import WebKit

struct BrowserView: View {
    @EnvironmentObject private var userData: UserData
    @State var shoutoutsButtonEnabled: Bool = true

    let article: Article

    private func incrementShoutouts() {
        userData.incrementShoutoutsCounter(article)
        shoutoutsButtonEnabled = userData.canIncrementShoutouts(article)
        let currentArticleShoutouts = max(userData.shoutoutsCache[article.id, default: 0], article.shoutouts)
        userData.shoutoutsCache[article.id, default: 0] = currentArticleShoutouts + 1
        // swiftlint:disable:next line_length
        let currentPublicationShoutouts = max(userData.shoutoutsCache[article.publication.id, default: 0], article.publication.shoutouts)
        userData.shoutoutsCache[article.publication.id, default: 0] = currentPublicationShoutouts + 1
        Network.shared.apollo.perform(mutation: IncrementShoutoutsMutation(id: article.id))
    }

    private var toolbar: some View {
        HStack(spacing: 0) {
            NavigationLink(destination: PublicationDetail(publication: article.publication)) {
                if let imageUrl = article.publication.profileImageUrl {
                    WebImage(url: imageUrl)
                        .grayBackground()
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 32, height: 32)
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 32, height: 32)
                }

                Spacer()
                    .frame(width: 7)

                Text("See more")
                    .font(.helveticaRegular(size: 12))
                    .foregroundColor(Color.black)
            }

            Spacer()

            Group {
                Button {
                    userData.toggleArticleSaved(article)
                } label: {
                    Image(systemName: userData.isArticleSaved(article) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(Color.volume.orange)
                }

                Spacer()
                    .frame(width: 16)

                Button {
                    incrementShoutouts()
                } label: {
                    Image("shout-out")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)
                        .foregroundColor(shoutoutsButtonEnabled ? Color.volume.orange : Color.gray)
                }
                .disabled(!shoutoutsButtonEnabled)

                Spacer()
                    .frame(width: 5)

                Text(String(max(article.shoutouts, userData.shoutoutsCache[article.id, default: 0])))
                    .font(.helveticaRegular(size: 12))
            }
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .background(Color.volume.backgroundGray)
        .onAppear(perform: {
            shoutoutsButtonEnabled = userData.canIncrementShoutouts(article)
        })
    }

    var body: some View {
        VStack(spacing: 0) {
            if let articleUrl = article.articleUrl {
                WebView(url: articleUrl)
            }
            toolbar
        }.toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text(article.publication.name)
                        .font(.begumBold(size: 12))
                    Text("Reading in Volume")
                        .font(.helveticaRegular(size: 10))
                        .foregroundColor(Color.volume.lightGray)
                }
            }
        }
    }
}

//struct BrowserView_Previews: PreviewProvider {
//    static var previews: some View {
//        BrowserView()
//    }
//}
