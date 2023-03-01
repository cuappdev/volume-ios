//
//  ReaderToolbarView.swift
//  Volume
//
//  Created by Hanzheng Li on 11/30/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import Combine
import SDWebImageSwiftUI
import SwiftUI

struct ReaderToolbarView<Content: ReadableContent>: View {

    let content: Content?
    let navigationSource: NavigationSource

    @EnvironmentObject private var userData: UserData
    @State private var bookmarkRequestInProgress: Bool = false
    @State private var queryBag = Set<AnyCancellable>()

    // MARK: Data

    private func incrementShoutouts(for content: Content) {
        guard let uuid = userData.uuid else {
            return
        }

        if let article = content as? Article {
            incrementShoutouts(for: article, uuid: uuid)
        } else if let magazine = content as? Magazine {
            incrementShoutouts(for: magazine, uuid: uuid)
        }
    }

    private func incrementShoutouts(for article: Article, uuid: String) {
        AppDevAnalytics.log(VolumeEvent.shoutoutArticle.toEvent(.article, value: article.id, navigationSource: navigationSource))

        userData.incrementShoutoutsCounter(article)
        userData.shoutoutsCache[article.id, default: 0] = numShoutouts(for: article as! Content) + 1
        let currentPublicationShoutouts = max(userData.shoutoutsCache[article.publication.slug, default: 0], article.publication.shoutouts)
        userData.shoutoutsCache[article.publication.slug, default: 0] = currentPublicationShoutouts + 1

        Network.shared.publisher(for: IncrementShoutoutsMutation(id: article.id, uuid: uuid))
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: IncrementShoutoutsMutation failed on BrowserView: \(error.localizedDescription)")
                }
            } receiveValue: { _ in }
            .store(in: &queryBag)
    }

    private func incrementShoutouts(for magazine: Magazine, uuid: String) {
        userData.incrementMagazineShoutoutsCounter(magazine)
        userData.magazineShoutoutsCache[magazine.id, default: 0] = numShoutouts(for: magazine as! Content) + 1
        let currentPublicationShoutouts = max(userData.shoutoutsCache[magazine.publication.slug, default: 0], magazine.publication.shoutouts)
        userData.shoutoutsCache[magazine.publication.slug, default: 0] = currentPublicationShoutouts + 1

        Network.shared.publisher(for: IncrementMagazineShoutoutsMutation(id: magazine.id, uuid: uuid))
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: IncrementMagazineShoutoutsMutation failed on MagazineReaderView: \(error.localizedDescription)")
                }
            } receiveValue: { _ in }
            .store(in: &queryBag)
    }

    private func toggleSaved(for content: Content) {
        bookmarkRequestInProgress = true

        if let article = content as? Article {
            userData.toggleArticleSaved(article, $bookmarkRequestInProgress)
            AppDevAnalytics.log(
                userData.isArticleSaved(article) ?
                VolumeEvent.bookmarkArticle.toEvent(.article, value: article.id, navigationSource: navigationSource) :
                    VolumeEvent.unbookmarkArticle.toEvent(.article, value: article.id, navigationSource: navigationSource)
            )
        } else if let magazine = content as? Magazine {
            userData.toggleMagazineSaved(magazine, $bookmarkRequestInProgress)
        }
    }

    private func isSaved(_ content: Content) -> Bool {
        if let article = content as? Article {
            return userData.isArticleSaved(article)
        } else if let magazine = content as? Magazine {
            return userData.isMagazineSaved(magazine)
        }

        return false
    }

    private func isShoutoutsButtonEnabled(for content: Content) -> Bool {
        if let article = content as? Article {
            return userData.canIncrementShoutouts(article)
        } else if let magazine = content as? Magazine {
            return userData.canIncrementMagazineShoutouts(magazine)
        }

        return false
    }

    private func numShoutouts(for content: Content) -> Int {
        if let article = content as? Article {
            return max(userData.shoutoutsCache[article.id, default: 0], article.shoutouts)
        } else if let magazine = content as? Magazine {
            return max(userData.magazineShoutoutsCache[magazine.id, default: 0], magazine.shoutouts)
        }

        return 0
    }

    // MARK: UI

    private func publicationDetailNavigationLink(content: Content) -> some View {
        NavigationLink {
            PublicationDetail(publication: content.publication, navigationSource: navigationSource)
        } label: {
            if let imageUrl = content.publication.profileImageUrl {
                WebImage(url: imageUrl)
                    .grayBackground()
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 32, height: 32)
            } else {
                Circle()
                    .fill(.gray)
                    .frame(width: 32, height: 32)
            }
            Spacer()
                .frame(width: 7)
            Text("See more")
                .font(.helveticaRegular(size: 12))
                .foregroundColor(.black)
        }
    }

    private func bookmarkButton(content: Content) -> some View {
        Button {
            toggleSaved(for: content)
        } label: {
            Image(systemName: isSaved(content) ? "bookmark.fill" : "bookmark")
                .font(Font.system(size: 18, weight: .semibold))
                .foregroundColor(.volume.orange)
        }
        .disabled(bookmarkRequestInProgress)
    }

    private func shareButton(content: Content) -> some View {
        Button {
            displayShareScreen(for: content)
        } label: {
            Image(systemName: "square.and.arrow.up.on.square")
                .font(Font.system(size: 16, weight: .semibold))
                .foregroundColor(.volume.orange)
        }
    }

    private func shoutoutButton(content: Content) -> some View {
        Group {
            Button {
                incrementShoutouts(for: content)
            } label: {
                Image.volume.shoutout
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                    .foregroundColor(isShoutoutsButtonEnabled(for: content) ? .volume.orange : .gray)
            }
            .disabled(!isShoutoutsButtonEnabled(for: content))

            Spacer()
                .frame(width: 6)

            Text(String(numShoutouts(for: content)))
                .font(.helveticaRegular(size: 12))
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            switch content {
            case .none:
                SkeletonView()
                    .frame(height: 0)
            case .some(let content):
                publicationDetailNavigationLink(content: content)

                Spacer()

                Group {
                    bookmarkButton(content: content)

                    Spacer()
                        .frame(width: 16)

                    shareButton(content: content)

                    Spacer()
                        .frame(width: 16)

                    shoutoutButton(content: content)
                }
            }
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .background(Color.white)
    }

    // MARK: Actions

    private func displayShareScreen(for content: Content) {
        var linkSource: LinkItemSource?

        if let article = content as? Article,
           let url = URL(string: "\(Secrets.openArticleUrl)\(article.id)") {
            linkSource = LinkItemSource(url: url, article: article)
            AppDevAnalytics.log(
                VolumeEvent.shareArticle.toEvent(
                    .article, value: article.id,
                    navigationSource: navigationSource
                )
            )
        } else if let magazine = content as? Magazine,
                  let url = URL(string: "\(Secrets.openMagazineUrl)\(magazine.id)") {
            linkSource = LinkItemSource(url: url, magazine: magazine)
        }

        guard let linkSource else {
            return
        }

        let shareVC = UIActivityViewController(activityItems: [linkSource], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(shareVC, animated: true)
    }
}
