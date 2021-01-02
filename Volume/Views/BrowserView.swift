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

    let article: Article

    private func incrementShoutouts() {
        // TODO: propagate this change immediately upon completion
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
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.black)
                        .frame(height: 24)
                }

                Spacer()
                    .frame(width: 5)

                Text(String(article.shoutOuts))
                    .font(.helveticaRegular(size: 12))
            }
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .background(Color.volume.backgroundGray)
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
