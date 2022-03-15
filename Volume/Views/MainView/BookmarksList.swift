//
//  BookmarksList.swift
//  Volume
//
//  Created by Cameron Russell on 11/15/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

struct BookmarksList: View {
    @State private var cancellableQuery: AnyCancellable?
    @State private var showSettings = false
    @State private var state: BookmarksListState = .loading
    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var userData: UserData

    private func fetch() {
        guard userData.savedArticleIDs.count > 0 else {
            state = .results([])
            return
        }

        cancellableQuery = userData.savedArticleIDs.publisher
            .map(GetArticleByIdQuery.init)
            .flatMap(Network.shared.publisher)
            .collect()
            .sink { completion in
                networkState.handleCompletion(screen: .bookmarksList, completion)
            } receiveValue: { value in
                let articles = [Article](value.compactMap(\.article?.fragments.articleFields)).sorted {
                    guard let index1 = userData.savedArticleIDs.firstIndex(of: $0.id) else { return true }
                    guard let index2 = userData.savedArticleIDs.firstIndex(of: $1.id) else { return true }
                    return index1 < index2
                }
                withAnimation(.linear(duration: 0.1)) {
                    state = .results(articles)
                }
            }
    }

    private var someFollowedArticles: Bool {
        switch state {
        case .loading:
            return userData.savedArticleIDs.count > 0
        case .results(let savedArticles):
            return savedArticles.count > 0
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                Header("Saved Articles")
                    .padding([.leading, .top, .trailing])
                    .padding(.bottom, 6)
                if someFollowedArticles {
                    switch state {
                    case .loading:
                        ForEach(0..<10) { _ in
                            ArticleRow.Skeleton()
                                .padding([.bottom, .leading, .trailing])
                        }
                    case .results(let savedArticles):
                        LazyVStack {
                            ForEach(savedArticles) { article in
                                ArticleRow(article: article, navigationSource: .bookmarkArticles)
                                    .padding([.bottom, .leading, .trailing])
                            }
                        }
                    }
                } else {
                    VStack {
                        Spacer(minLength: geometry.size.height / 5)
                        VolumeMessage(message: .noBookmarks)
                    }
                }
            }
            .disabled(state == .loading)
            .padding(.top)
            .background(Color.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BubblePeriodText("Bookmarks")
                        .font(.begumMedium(size: 28))
                        .offset(y: 8)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Image.volume.settings
                        .offset(x: -5, y: 5)
                        .onTapGesture {
                            showSettings = true
                        }
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: fetch)
            .background(
                NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                    EmptyView()
                }
            )
        }
    }
}

extension BookmarksList {
    private enum BookmarksListState: Equatable {
        case loading
        case results([Article])
    }
}

struct BookmarksList_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksList()
    }
}
