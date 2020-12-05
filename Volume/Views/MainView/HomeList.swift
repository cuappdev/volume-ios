//
//  HomeList.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

struct HomeList: View {
    @State private var trendingArticles: [Article] = []
    @State private var followingArticles: [Article] = []
    @State private var otherArticles: [Article] = []
    @State private var cancellableQuery: Cancellable?
    
    private func fetch() {
        guard let date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
            return
        }
        let query = GetHomeArticlesQuery(since: date.dateString)
        cancellableQuery = Network.shared.apollo.fetch(query: query)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { value in
                trendingArticles = [Article](value.trending)
                followingArticles = [Article](value.following)
                otherArticles = [Article](value.other)
            })
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    Header("The Big Read").padding(.bottom, -12)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 24) {
                            ForEach(trendingArticles) { article in
                                BigReadArticleRow(article: article)
                            }
                        }
                    }
                    .padding([.bottom, .leading, .trailing])

                    Header("Following").padding(.bottom, -12)
                    ForEach(followingArticles) { article in
                        ArticleRow(article: article)
                            .padding([.bottom, .leading, .trailing])
                    }
                    
                    VolumeMessage(message: .upToDate)
                        .padding([.top, .bottom], 25)
                    
                    Header("Other Articles").padding(.bottom, -12)
                    ForEach(otherArticles) { article in
                        ArticleRow(article: article)
                            .padding([.bottom, .leading, .trailing])
                    }
                }
            }
            .background(Color.volume.backgroundGray)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Image("volume-logo")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: fetch)
        }
    }
}

struct HomeList_Previews: PreviewProvider {
    static var previews: some View {
        HomeList()
    }
}
