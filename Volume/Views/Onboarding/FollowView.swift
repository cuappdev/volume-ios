//
//  FollowView.swift
//  Volume
//
//  Created by Daniel Vebman on 11/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension OnboardingView {
    struct FollowView: View {
        @State private var contentOffset: CGPoint = .zero
        @State private var maxContentOffset: CGPoint = .zero
        @State private var cancellableQuery: AnyCancellable?
        @State private var state: FollowViewState = .loading

        private func fetch() {
            cancellableQuery = Network.shared.apollo.fetch(query: GetAllPublicationsQuery())
                .map { data in data.publications.compactMap { $0.fragments.publicationFields } }
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print(error.localizedDescription)
                    }
                }, receiveValue: { value in
                    state = .results([Publication](value))
                })
        }

        var body: some View {
            TrackableScrollView(
                contentOffset: $contentOffset,
                maxOffsetDidChange: { self.maxContentOffset = $0 }
            ) {
                LazyVStack(spacing: 24) {
                    switch state {
                    case .loading:
                        ForEach(0..<4) { _ in
                            MorePublicationRow.Skeleton()
                        }
                    case .results(let publications):
                        ForEach(publications) { publication in
                            MorePublicationRow(publication: publication)
                        }
                    }
                }
                .background(Color.volume.backgroundGray)
            }
            .overlay(
                VStack {
                    fadeView(fadesDown: false)
                        .opacity(contentOffset.y > 0 ? 1 : 0)
                    Spacer()
                    fadeView(fadesDown: true)
                        .opacity(
                            contentOffset.y < maxContentOffset.y - 1
                                || maxContentOffset.y == 0
                                ? 1 : 0
                        )
                }
                .transition(.opacity)
                .animation(.linear(duration: 0.2))
            )
            .padding(.top, 48)
            .disabled(state == .loading)
            .transition(.move(edge: .trailing))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: fetch)
            }
        }
    }
}

extension OnboardingView.FollowView {
    /// `fadesDown` if the fade gets stronger (more opaque) at the bottom
    private func fadeView(fadesDown: Bool) -> some View {
        Group {
            if fadesDown {
                Spacer()
            }
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.volume.backgroundGray.opacity(0),
                        Color.volume.backgroundGray
                    ]
                ),
                startPoint: fadesDown ? .top : .bottom,
                endPoint: fadesDown ? .bottom : .top
            )
            .frame(height: 50)
            if !fadesDown {
                Spacer()
            }
        }
    }
}

extension OnboardingView.FollowView {
    private enum FollowViewState: Equatable {
        case loading
        case results([Publication])
    }
}

//struct FollowView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView.FollowView()
//    }
//}
//