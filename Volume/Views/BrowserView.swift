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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var userData: UserData

    let initType: BrowserViewInitType
    let navigationSource: NavigationSource
    @State private var cancellableArticleQuery: AnyCancellable?
    @State private var cancellableReadMutation: AnyCancellable?
    @State private var cancellableShoutoutMutation: AnyCancellable?
    @State private var state: BrowserViewState<Article> = .loading
    @State private var showToolbars = true
    
    private var isShoutoutsButtonEnabled: Bool {
        switch state {
        case .loading:
            return false
        case .results(let article):
            return userData.canIncrementShoutouts(article)
        }
    }
    
    private var navigationTitle: String {
        switch state {
        case .loading:
            return "Loading article..."
        case .results(let article):
            return article.publication.name
        }
    }
    
    private var isArticleLoaded: Bool {
        switch state {
        case .loading:
            return true
        case .results(_):
            return false
        }
    }
    
    // MARK: UI Components
    
    private var navbar: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 2, y: 3)
                
                if showToolbars {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image.volume.leftArrow
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 24)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        if case let .results(article) = state, let url = article.articleUrl {
                            Link(destination: url) {
                                Image.volume.compass
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 24)
                                    .foregroundColor(.black)
                            }
                        } else {
                            Image.volume.compass
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 24)
                                .foregroundColor(.volume.lightGray)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    VStack {
                        Text(navigationTitle)
                            .font(.newYorkBold(size: 12))
                            .truncationMode(.tail)
                        Text("Reading in Volume")
                            .font(.helveticaRegular(size: 10))
                            .foregroundColor(.volume.lightGray)
                    }
                    .padding(.horizontal, 48)
                } else {
                    Text(navigationTitle)
                        .font(.newYorkBold(size: 10))
                        .fixedSize()
                }
            }
            .background(Color.white)
            .frame(height: showToolbars ? 40 : 20)
    }
    
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
                            .fill(.gray)
                            .frame(width: 32, height: 32)
                    }
                    Spacer()
                        .frame(width: 7)
                    Text("See more")
                        .font(.helveticaRegular(size: 12))
                        .foregroundColor(.black)
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
                            .foregroundColor(.volume.orange)
                    }
                    
                    Spacer()
                        .frame(width: 16)
                    
                    Button {
                        AppDevAnalytics.log(VolumeEvent.shareArticle.toEvent(.article, value: article.id, navigationSource: navigationSource))
                        displayShareScreen(for: article)
                    } label: {
                        Image(systemName: "square.and.arrow.up.on.square")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(.volume.orange)
                    }
                    
                    Spacer()
                        .frame(width: 16)
                    
                    Button {
                        incrementShoutouts(for: article)
                    } label: {
                        Image.volume.shoutout
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)
                            .foregroundColor(isShoutoutsButtonEnabled ? .volume.orange : .gray)
                    }
                    .disabled(!isShoutoutsButtonEnabled)
                    
                    Spacer()
                        .frame(width: 6)
                    
                    Text(String(max(article.shoutouts, userData.shoutoutsCache[article.id, default: 0])))
                        .font(.helveticaRegular(size: 12))
                }
            }
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .background(Color.white)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: showToolbars ? 40 : 20)
                
                switch state {
                case .loading:
                    SkeletonView()
                case .results(let article):
                    if let articleUrl = article.articleUrl {
                        WebView(url: articleUrl, showToolbars: $showToolbars)
                            .onAppear {
                                AppDevAnalytics.log(VolumeEvent.openArticle.toEvent(.article, value: article.id, navigationSource: navigationSource))
                                markArticleRead(id: article.id)
                            }
                            .onDisappear {
                                AppDevAnalytics.log(VolumeEvent.closeArticle.toEvent(.article, value: article.id, navigationSource: navigationSource))
                            }
                    }
                }
                if showToolbars {
                    toolbar
                }
            }
            VStack(spacing: 0) {
                navbar
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
        guard let uuid = userData.uuid else { return }
        
        AppDevAnalytics.log(VolumeEvent.shoutoutArticle.toEvent(.article, value: article.id, navigationSource: navigationSource))
        userData.incrementShoutoutsCounter(article)
        let currentArticleShoutouts = max(userData.shoutoutsCache[article.id, default: 0], article.shoutouts)
        userData.shoutoutsCache[article.id, default: 0] = currentArticleShoutouts + 1
        // swiftlint:disable:next line_length
        let currentPublicationShoutouts = max(userData.shoutoutsCache[article.publication.slug, default: 0], article.publication.shoutouts)
        userData.shoutoutsCache[article.publication.slug, default: 0] = currentPublicationShoutouts + 1
        cancellableShoutoutMutation = Network.shared.publisher(for: IncrementShoutoutsMutation(id: article.id, uuid: uuid))
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: IncrementShoutoutsMutation failed on BrowserView: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in })
    }
    
    private func fetchArticleBy(id: String) {
        state = .loading
        cancellableArticleQuery = Network.shared.publisher(for: GetArticleByIdQuery(id: id))
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: GetArticleByIdQuery failed on BrowserView: \(error.localizedDescription)")
                }
            } receiveValue: { article in
                if let fields = article.article?.fragments.articleFields {
                    state = .results(Article(from: fields))
                    markArticleRead(id: id)
                }
            }
    }
    
    private func markArticleRead(id: String) {
        guard let uuid = userData.uuid else { return }
        cancellableReadMutation = Network.shared.publisher(for: ReadArticleMutation(id: id, uuid: uuid))
            .map(\.readArticle?.id)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: ReadArticleMutation failed on BrowserView: \(error.localizedDescription)")
                }
            } receiveValue: { id in
                #if DEBUG
                print("Marked article read with ID: \(id ?? "nil")")
                #endif
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
    
    enum BrowserViewInitType {
        case readyForDisplay(Article), fetchRequired(ArticleID)
    }
}
