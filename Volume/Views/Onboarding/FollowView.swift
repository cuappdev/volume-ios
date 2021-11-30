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
        @State private var cancellableQuery: AnyCancellable?
        @State private var state: FollowViewState = .loading
        private let scrollViewCoordinateSpace = "scrollViewCoordinateSpace"
        
        private func fetch() {
            cancellableQuery = Network.shared.publisher(for: GetAllPublicationsQuery())
                .map { data in data.publications.compactMap { $0.fragments.publicationFields } }
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print(error.localizedDescription)
                    }
                }, receiveValue: { value in
                    let publications = [Publication](value)
                    state = .results(publications)
                })
        }
        
        var body: some View {
            ScrollView {
                LazyVStack(spacing: 24) {
                    switch state {
                    case .loading:
                        ForEach(0..<4) { _ in
                            MorePublicationRow.Skeleton()
                        }
                    case .results(let publications):
                        ForEach(publications) { publication in
                            MorePublicationRow(publication: publication, navigationSource: .onboarding)
                        }
                    }
                }
                .padding(.bottom, 48)
                .background(
                    GeometryReader { proxy in
                        let offset = -proxy.frame(in: .named(scrollViewCoordinateSpace)).origin.y
                        Color.volume.backgroundGray
                            .preference(key: OffsetPreferenceKey.self, value: offset)
                    }
                )
            }
            .coordinateSpace(name: scrollViewCoordinateSpace)
            .onPreferenceChange(OffsetPreferenceKey.self) {
                contentOffset.y = $0
            }
            .overlay(
                VStack {
                    fadeView(fadesDown: false)
                        .opacity(contentOffset.y > 0 ? 1 : 0)
                        .transition(.opacity)
                        .animation(.linear(duration: 0.2))
                    Spacer()
                    fadeView(fadesDown: true)
                }
            )
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

extension OnboardingView.FollowView {
    private struct OffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
    }
    
    private struct MaxOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
    }
}

//struct FollowView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView.FollowView()
//    }
//}
//
