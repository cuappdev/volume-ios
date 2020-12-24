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
    @State private var cancellableQueries: Set<AnyCancellable> = Set()
    @State private var state: BookmarksListState = .loading
    @EnvironmentObject private var userData: UserData
    
    private func fetch() {
        guard userData.savedArticleIDs.count > 0 else {
            state = .results([])
            return
        }
        
        userData.savedArticleIDs.publisher
            .map(GetArticleByIdQuery.init)
            .flatMap(Network.shared.apollo.fetch)
            .collect()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { value in
                withAnimation(.linear(duration: 0.1)) {
                    state = .results([Article](value.map(\.article)))
                }
            }.store(in: &cancellableQueries)
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
            NavigationView {
                ScrollView(showsIndicators: false) {
                    Header("Saved Articles").padding(.bottom, -12)
                    if someFollowedArticles {
                        switch state {
                        case .loading:
                            ForEach(0..<10) { _ in
                                ArticleRow.Skeleton()
                                    .padding([.bottom, .leading, .trailing])
                            }
                        case .results(let savedArticles):
                            LazyVStack {
                                ForEach (savedArticles) { article in
                                    ArticleRow(article: article)
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
                .background(Color.volume.backgroundGray)
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        BubblePeriodText("Bookmarks")
                            .font(.begumMedium(size: 28))
                            .offset(y: 8)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(perform: fetch)
            }
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
