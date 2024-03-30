//
//  OnboardingPublicationsView.swift
//  Volume
//
//  Created by Vin Bui on 4/23/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import OSLog
import SwiftUI

struct OnboardingPublicationsView: View {

    // MARK: - Properties

    @State private var cancellableQuery: AnyCancellable?
    @State private var contentOffset: CGPoint = .zero
    @State private var publications: [Publication]?

    private let scrollViewCoordinateSpace = "scrollViewCoordinateSpace"

    // MARK: - Constants

    private struct Constants {
        static let spacing: CGFloat = 24
        static let verticalPadding: CGFloat = 30
    }

    // MARK: - UI

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: Constants.spacing) {
                switch publications {
                case .none:
                    ForEach(0..<4) { _ in
                        MorePublicationRow.Skeleton()
                            .shimmer(.init(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
                    }
                case .some(let publications):
                    ForEach(publications) { publication in
                        MorePublicationRow(publication: publication, navigationSource: .onboarding)
                    }
                }
            }
            .background(
                GeometryReader { proxy in
                    let offset = -proxy.frame(in: .named(scrollViewCoordinateSpace)).origin.y
                    Color.white
                        .preference(key: OffsetPreferenceKey.self, value: offset)
                }
            )
            .padding(.bottom, Constants.verticalPadding)
        }
        .coordinateSpace(name: scrollViewCoordinateSpace)
        .onPreferenceChange(OffsetPreferenceKey.self) {
            contentOffset.y = $0
        }
        .overlay(
            VStack {
                withAnimation(.linear(duration: 0.2)) {
                    ScrollFadingView(fadesDown: false)
                        .opacity(contentOffset.y > 0 ? 1 : 0)
                        .transition(.opacity)
                }

                Spacer()

                ScrollFadingView(fadesDown: true)
            }
        )
        .transition(.move(edge: .trailing))
        .onAppear {
            Task {
                await fetchPublications()
            }
        }
    }

    // MARK: - Helpers

    private func fetchPublications() async {
        cancellableQuery = Network.client.queryPublisher(query: VolumeAPI.GetAllPublicationsQuery())
            .compactMap { $0.data?.publications.map(\.fragments.publicationFields) }
            .sink { completion in
                if case let .failure(error) = completion {
                    // swiftlint:disable:next line_length
                    Logger.services.error("Error: GetAllPublicationsQuery failed on OnboardingPublicationsView: \(error.localizedDescription)")
                }
            } receiveValue: { publicationFields in
                publications = [Publication](publicationFields)
            }
    }

}

extension OnboardingPublicationsView {

    private struct OffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
    }

}

// MARK: - Uncomment below if needed

//struct OnboardingPublicationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingPublicationsView()
//    }
//}
