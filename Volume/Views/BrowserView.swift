//
//  BrowserView.swift
//  Volume
//
//  Created by Daniel Vebman on 12/31/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import Combine
import LinkPresentation
import SDWebImageSwiftUI
import SwiftUI
import WebKit

struct BrowserView: View {
    @EnvironmentObject private var userData: UserData
    
    let initType: BrowserViewInitType
    let navigationSource: NavigationSource
    @State private var cancellableShoutoutMutation: AnyCancellable?
    @State private var cancellableArticleQuery: AnyCancellable?
    @State private var state: BrowserViewState<Article> = .loading
    
    var isShoutoutsButtonEnabled: Bool {
        switch state {
        case .loading:
            return false
        case .results(let article):
            return userData.canIncrementShoutouts(article)
        }
    }
    
    // MARK: UI Components
    
    private var toolbar: some View {
        HStack(spacing: 0) {
            switch state {
            case .loading:
                SkeletonView()
                    .frame(height: 0)
            case .results(let article):
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
                            VolumeEvent.bookmarkArticle.toEvent(.article, value: article.id, navigationSource: navigationSource) :
                                VolumeEvent.unbookmarkArticle.toEvent(.article, value: article.id, navigationSource: navigationSource)
                        )
                    } label: {
                        Image(systemName: userData.isArticleSaved(article) ? "bookmark.fill" : "bookmark")
                            .font(Font.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.volume.orange)
                    }
                    Spacer()
                        .frame(width: 16)
                    Button {
                        AppDevAnalytics.log(VolumeEvent.shareArticle.toEvent(.article, value: article.id, navigationSource: navigationSource))
                        displayShareScreen(for: article)
                    } label: {
                        Image(systemName: "square.and.arrow.up.on.square")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.volume.orange)
                    }
                    Spacer()
                        .frame(width: 16)
                    Button {
                        incrementShoutouts(for: article)
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
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .background(Color.volume.backgroundGray)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            switch state {
            case .loading:
                SkeletonView()
            case .results(let article):
                if let articleUrl = article.articleUrl {
                    WebView(url: articleUrl)
                        .onAppear {
                            AppDevAnalytics.log(VolumeEvent.openArticle.toEvent(.article, value: article.id, navigationSource: navigationSource))
                        }
                        .onDisappear {
                            AppDevAnalytics.log(VolumeEvent.closeArticle.toEvent(.article, value: article.id, navigationSource: navigationSource))
                        }
                }
            }
            toolbar
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    switch state {
                    case .loading:
                        Text("Loading article...")
                            .font(.begumBold(size: 12))
                    case .results(let article):
                        Text(article.publication.name)
                            .font(.begumBold(size: 12))
                    }
                    Text("Reading in Volume")
                        .font(.latoRegular(size: 10))
                        .foregroundColor(Color.volume.lightGray)
                }
            }
        }
        .onAppear {
            switch initType {
            case .fetchRequired(let id):
                fetchArticleBy(id: id)
            case .readyForDisplay(let article):
                state = .results(article)
            }
        }
        .onOpenURL { url in
            if url.isDeeplink {
                if let id = url.parameters["id"] {
                    fetchArticleBy(id: id)
                }
            }
        }
    }
    
    // MARK: Actions
    
    private func incrementShoutouts(for article: Article) {
        AppDevAnalytics.log(VolumeEvent.shoutoutArticle.toEvent(.article, value: article.id, navigationSource: navigationSource))
        userData.incrementShoutoutsCounter(article)
        let currentArticleShoutouts = max(userData.shoutoutsCache[article.id, default: 0], article.shoutouts)
        userData.shoutoutsCache[article.id, default: 0] = currentArticleShoutouts + 1
        // swiftlint:disable:next line_length
        let currentPublicationShoutouts = max(userData.shoutoutsCache[article.publication.id, default: 0], article.publication.shoutouts)
        userData.shoutoutsCache[article.publication.id, default: 0] = currentPublicationShoutouts + 1
        cancellableShoutoutMutation = Network.shared.publisher(for: IncrementShoutoutsMutation(id: article.id))
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { _ in })
    }
    
    private func fetchArticleBy(id: String) {
        state = .loading
        cancellableArticleQuery = Network.shared.publisher(for: GetArticleByIdQuery(id: id))
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { article in
                if let fields = article.article?.fragments.articleFields {
                    state = .results(Article(from: fields))
                }
            }
    }
    
    func displayShareScreen(for article: Article) {
        let rawString = Secrets.openArticleUrl + article.id
        if let shareArticleUrl = URL(string: rawString) {
            let linkSource = LinkItemSource(url: shareArticleUrl, article: article)
            let shareVC = UIActivityViewController(activityItems: [linkSource], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(shareVC, animated: true)
        }
    }
}

extension BrowserView {
    private enum BrowserViewState<Results> {
        case loading, results(Results)
    }
    
    public enum BrowserViewInitType {
        case readyForDisplay(Article), fetchRequired(ArticleID)
    }
}
