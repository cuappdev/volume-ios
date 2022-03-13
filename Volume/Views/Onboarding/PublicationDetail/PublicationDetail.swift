//
//  PublicationDetail.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Combine
import SDWebImageSwiftUI
import SwiftUI

/// `PublicationDetail` displays detailed information about a publication
struct PublicationDetail: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    @State private var cancellableIDQuery: AnyCancellable?
    @State private var cancellableArticlesQuery: AnyCancellable?
    @State private var state: PublicationDetailState = .loading

    let navigationSource: NavigationSource
    let publication: Publication

    private func fetch() {
        cancellableIDQuery = Network.shared.publisher(for: GetPublicationBySlugQuery(slug: publication.slug))
            .map { $0.publication.map({ $0.fragments.publicationFields.id })! }
            .sink {
                if case let .failure(error) = $0 {
                    print("Error: GetPublicationBySlugQuery failed on PublicationDetail: \(error.localizedDescription)")
                }
            } receiveValue: {
                fetchArticles(by: $0)
            }
    }

    private func fetchArticles(by publicationID: String) {
        cancellableArticlesQuery = Network.shared.publisher(for: GetArticlesByPublicationIdQuery(id: publicationID))
            .map(\.articles)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: GetArticlesByPublicationIdQuery failed on PublicationDetail: \(error.localizedDescription)")
                }
            }, receiveValue: { value in
                withAnimation(.linear(duration: 0.1)) {
                    state = .results([Article](value.map(\.fragments.articleFields)).sorted(by: { $0.date > $1.date }))
                }
            })
    }

    private var isLoading: Bool {
        switch state {
        case .loading:
            return true
        case .results:
            return false
        }
    }

    private var backgroundImage: some View {
        ZStack {
            GeometryReader { geometry in
                if let url = publication.backgroundImageUrl {
                    WebImage(url: url)
                        .resizable()
                        .grayBackground()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: 140)
                        .clipped()
                } else {
                    Rectangle() // TODO: Custom image
                        .frame(width: geometry.size.width, height: 140)
                        .foregroundColor(.blue)
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("back-arrow")
                            .padding(.top, 55)
                            .padding(.leading, 20)
                    }

                    Spacer()

                    if let imageUrl = publication.profileImageUrl {
                        WebImage(url: imageUrl)
                            .grayBackground()
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 60, height: 60)
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            .shadow(color: .volume.shadowBlack, radius: 5, x: 0, y: 0)
                            .padding(.leading, 16)
                    } else {
                        Circle()
                            .frame(width: 60, height: 60)
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            .shadow(color: .volume.shadowBlack, radius: 5, x: 0, y: 0)
                            .padding(.leading, 16)
                    }
                }

                Spacer()
            }
        }
        .frame(height: 156)
    }

    var body: some View {
        Section {
            ScrollView {
                backgroundImage
                PublicationDetailHeader(navigationSource: navigationSource, publication: publication)
                    .padding(.bottom)
                Divider()
                    .background(Color.volume.buttonGray)
                    .frame(width: 100)
                Header("Articles")
                    .padding()
                
                switch state {
                case .loading:
                    VStack {
                        ForEach(0..<5) { _ in
                            ArticleRow.Skeleton(showsPublicationName: false)
                                .padding([.bottom, .leading, .trailing])
                        }
                    }
                case .results(let articles):
                    LazyVStack {
                        ForEach(articles) { article in
                            ArticleRow(article: article, navigationSource: navigationSource, showsPublicationName: false)
                                .padding([.bottom, .leading, .trailing])
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            .disabled(isLoading)
        }
        .background(Color.white)
        .gesture(
            DragGesture().updating($dragOffset, body: { value, _, _ in
                if value.startLocation.x < 20 && value.translation.width > 100 {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        )
        .onAppear(perform: fetch)
    }
}

extension PublicationDetail {
    private enum PublicationDetailState {
        case loading
        case results([Article])
    }
}

//struct PublicationDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PublicationDetail(
//            publication: Publication(
//                description: "A publication bringing you only the collest horse facts.",
//                name: "Guac",
//                id: "asdfsf39201sd923k",
//                imageURL: nil,
//                recent: "Horses love to swim"
//            )
//        )
//    }
//}
