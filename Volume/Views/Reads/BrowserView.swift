//
//  BrowserView.swift
//  Volume
//
//  Created by Daniel Vebman on 12/31/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Combine
import LinkPresentation
import OSLog
import SDWebImageSwiftUI
import SwiftUI
import WebKit

struct BrowserView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var userData: UserData

    let initType: ReaderViewInitType<Article>
    let navigationSource: NavigationSource
    @State private var cancellableArticleQuery: AnyCancellable?
    @State private var cancellableReadMutation: AnyCancellable?
    @State private var state: BrowserViewState<Article> = .loading
    @State private var showToolbars = true

    private var navigationTitle: String {
        switch state {
        case .loading:
            return "Loading article..."
        case .results(let article):
            return article.publication.name
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
        Group {
            if case .results(let article) = state {
                ReaderToolbarView(content: article, navigationSource: .articleDetail)
            } else {
                ReaderToolbarView<Article>(content: nil, navigationSource: .articleDetail)
            }
        }
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
                                AnalyticsManager.shared.log(
                                    VolumeEvent.openArticle.toEvent(
                                        type: .article,
                                        value: article.id,
                                        navigationSource: navigationSource
                                    )
                                )
                                markArticleRead(id: article.id)
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

    private func fetchArticleBy(id: String) {
        state = .loading
        cancellableArticleQuery = Network.client.queryPublisher(query: VolumeAPI.GetArticleByIDQuery(id: id))
            .compactMap { $0.data?.article.map(\.fragments.articleFields) }
            .sink { completion in
                if case let .failure(error) = completion {
                    Logger.services.error("Error: GetArticleByIdQuery failed on BrowserView: \(error.localizedDescription)")
                }
            } receiveValue: { articleFields in
                state = .results(Article(from: articleFields))
                markArticleRead(id: id)
            }
    }

    private func markArticleRead(id: String) {
        guard let uuid = userData.uuid else { return }
        cancellableReadMutation = Network.client.mutationPublisher(
            mutation: VolumeAPI.ReadArticleMutation(
                id: id,
                uuid: uuid
            )
        )
        .map(\.data?.readArticle?.id)
        .sink { completion in
            if case let .failure(error) = completion {
                Logger.services.error("Error: ReadArticleMutation failed on BrowserView: \(error.localizedDescription)")
            }
        } receiveValue: { id in
#if DEBUG
            Logger.services.log("Marked article read with ID: \(id ?? "nil")")
#endif
        }
    }
}

extension BrowserView {
    private enum BrowserViewState<Results> {
        case loading, results(Results)
    }
}
