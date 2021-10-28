//
//  BrowserView.swift
//  Volume
//
//  Created by Daniel Vebman on 12/31/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import LinkPresentation
import SDWebImageSwiftUI
import SwiftUI
import WebKit

struct BrowserView: View {
    @EnvironmentObject private var userData: UserData

    let article: Article
    let navigationSource: NavigationSource

    var isShoutoutsButtonEnabled: Bool {
        userData.canIncrementShoutouts(article)
    }

    private func incrementShoutouts() {
        AppDevAnalytics.log(VolumeEvent.shoutoutArticle.toEvent(.article, id: article.id, navigationSource: navigationSource))
        userData.incrementShoutoutsCounter(article)
        let currentArticleShoutouts = max(userData.shoutoutsCache[article.id, default: 0], article.shoutouts)
        userData.shoutoutsCache[article.id, default: 0] = currentArticleShoutouts + 1
        // swiftlint:disable:next line_length
        let currentPublicationShoutouts = max(userData.shoutoutsCache[article.publication.id, default: 0], article.publication.shoutouts)
        userData.shoutoutsCache[article.publication.id, default: 0] = currentPublicationShoutouts + 1
        Network.shared.apollo.perform(mutation: IncrementShoutoutsMutation(id: article.id))
    }

    private var toolbar: some View {
        HStack(spacing: 0) {
            NavigationLink(destination: PublicationDetail(navigationSource: navigationSource, publication: article.publication)) {
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
                    .font(.latoRegular(size: 12))
                    .foregroundColor(Color.black)
            }

            Spacer()

            Group {
                Button {
                    userData.toggleArticleSaved(article)
                    AppDevAnalytics.log(
                        userData.isArticleSaved(article) ?
                            VolumeEvent.bookmarkArticle.toEvent(.article, id: article.id, navigationSource: navigationSource) :
                            VolumeEvent.unbookmarkArticle.toEvent(.article, id: article.id, navigationSource: navigationSource)
                    )
                } label: {
                    Image(systemName: userData.isArticleSaved(article) ? "bookmark.fill" : "bookmark")
                        .font(Font.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.volume.orange)
                }

                Spacer()
                    .frame(width: 16)

                Button {
                    AppDevAnalytics.log(VolumeEvent.shareArticle.toEvent(.article, id: article.id, navigationSource: navigationSource))
                    displayShareScreen()
                } label: {
                    Image(systemName: "square.and.arrow.up.on.square")
                        .font(Font.system(size: 16, weight: .semibold))
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
                        .frame(height: 24)
                        .foregroundColor(isShoutoutsButtonEnabled ? Color.volume.orange : Color.gray)
                }
                .disabled(!isShoutoutsButtonEnabled)

                Spacer()
                    .frame(width: 6)

                Text(String(max(article.shoutouts, userData.shoutoutsCache[article.id, default: 0])))
                    .font(.latoRegular(size: 12))
            }
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .background(Color.volume.backgroundGray)
    }

    func displayShareScreen() {
        let rawString = Secrets.openArticleUrl + article.id
        if let shareArticleUrl = URL(string: rawString) {
            let linkSource = LinkItemSource(url: shareArticleUrl, article: article)
            let shareVC = UIActivityViewController(activityItems: [linkSource], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(shareVC, animated: true)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            if let articleUrl = article.articleUrl {
                WebView(url: articleUrl)
                    .onAppear {
                        AppDevAnalytics.log(VolumeEvent.openArticle.toEvent(.article, id: article.id, navigationSource: navigationSource))
                    }
                    .onDisappear {
                        AppDevAnalytics.log(VolumeEvent.closeArticle.toEvent(.article, id: article.id, navigationSource: navigationSource))
                    }
            }
            toolbar
        }.toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text(article.publication.name)
                        .font(.begumBold(size: 12))
                    Text("Reading in Volume")
                        .font(.latoRegular(size: 10))
                        .foregroundColor(Color.volume.lightGray)
                }
            }
        }
    }
}
