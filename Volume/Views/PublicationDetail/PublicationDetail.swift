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
    @State private var cancellableQuery: AnyCancellable?
    @State private var state: PublicationDetailState = .loading

    let entryPoint: EntryPoint
    let publication: Publication

    private func fetch() {
        cancellableQuery = Network.shared.apollo.fetch(query: GetArticlesByPublicationIdQuery(id: publication.id))
            .map(\.articles)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { value in
                withAnimation(.linear(duration: 0.1)) {
                    state = .results([Article](value.map(\.fragments.articleFields)))
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
                            .shadow(color: Color.volume.shadowBlack, radius: 5, x: 0, y: 0)
                            .padding(.leading, 16)
                    } else {
                        Circle()
                            .frame(width: 60, height: 60)
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            .shadow(color: Color.volume.shadowBlack, radius: 5, x: 0, y: 0)
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

                PublicationDetailHeader(entryPoint: entryPoint, publication: publication)
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
                            ArticleRow(article: article, entryPoint: entryPoint, showsPublicationName: false)
                                .padding([.bottom, .leading, .trailing])
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            .disabled(isLoading)
        }
        .background(Color.volume.backgroundGray)
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
