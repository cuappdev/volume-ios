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
    @EnvironmentObject private var userData: UserData
    @State private var savedArticles: [Article] = []
    
    private func fetch() {
        userData.savedArticleIDs.publisher
            .map(GetArticleByIdQuery.init)
            .flatMap(Network.shared.apollo.fetch)
            .collect()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { value in
                savedArticles = [Article](value.map(\.article))
            }.store(in: &cancellableQueries)
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView(showsIndicators: false) {
                    Header("Saved Articles").padding(.bottom, -12)
                    if savedArticles.count > 0 {
                        LazyVStack {
                            ForEach (savedArticles) { article in
                                ArticleRow(article: article)
                                    .padding([.bottom, .leading, .trailing])
                            }
                        }
                    } else {
                        VStack {
                            Spacer(minLength: geometry.size.height / 5)
                            VolumeMessage(message: .noBookmarks)
                        }
                    }
                }
                .background(Color.volume.backgroundGray)
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        BubblePeriodText("Bookmarks")
                            .font(.begumMedium(size: 28))
                            .offset(y: 8)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }.onAppear(perform: fetch)
    }
}

struct BookmarksList_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksList()
    }
}
