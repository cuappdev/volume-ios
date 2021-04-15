//
//  PublicationList.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

struct PublicationList: View {
    @State private var cancellableQuery: AnyCancellable?
    @State private var state: PublicationListState = .loading
    @EnvironmentObject private var userData: UserData

    private func fetch(_ done: @escaping () -> Void = { }) {
        // if there already are results, sort again `onAppear` in case a `followed` status changed
        if case .results(let results) = state {
            let publications = results.followedPublications + results.morePublications
            let followedPublications = publications.filter(userData.isPublicationFollowed)
            let morePublications = publications.filter { !userData.isPublicationFollowed($0) }
            state = .results((followedPublications, morePublications))
        }

        cancellableQuery = Network.shared.apollo.fetch(query: GetAllPublicationsQuery())
            .map { data in data.publications.compactMap { $0 } }
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { value in
                let publications = [Publication](value.map(\.fragments.publicationFields))
                let followedPublications = publications.filter(userData.isPublicationFollowed)
                let morePublications = publications.filter { !userData.isPublicationFollowed($0) }
                
                done()
                withAnimation(.linear(duration: 0.1)) {
                    state = .results((followedPublications, morePublications))
                }
            })
    }

    // Whether, given the state, at least 1 publication is followed. These two may differ if a
    // publication which was already followed is suddenly not returned from the server.
    private var someFollowedPublications: Bool {
        switch state {
        case .loading:
            return userData.followedPublicationIDs.count > 0
        case .reloading(let results), .results(let results):
            return results.followedPublications.count > 0
        }
    }

    private var isLoading: Bool {
        switch state {
        case .loading:
            return true
        default:
            return false
        }
    }

    /// The publications a user is following
    private var followedPublicationsSection: some View {
        Section(
            header: Header("Following")
                .padding([.leading, .top, .trailing])
                .padding(.bottom, 6)
        ) {
            if someFollowedPublications {
                ScrollView(.horizontal, showsIndicators: false) {
                    switch state {
                    case .loading:
                        HStack(spacing: 12) {
                            ForEach(0..<userData.followedPublicationIDs.count) { _ in
                                FollowingPublicationRow.Skeleton()
                            }
                        }
                        .padding([.leading, .trailing], 10)
                    case .reloading(let results), .results(let results):
                        HStack(spacing: 12) {
                            ForEach(results.followedPublications) { publication in
                                NavigationLink(destination: PublicationDetail(navigationSource: .followingPublications, publication: publication)) {
                                    FollowingPublicationRow(publication: publication)
                                }
                            }
                        }
                        .padding([.leading, .trailing], 10)
                    }
                }
            } else {
                VStack(spacing: 10) {
                    Text("You're not following any publications")
                        .lineLimit(2)
                        .font(.helveticaBold(size: 16))
                    Text("Follow some below and we'll show them up here")
                        .lineLimit(2)
                        .font(.helveticaRegular(size: 12))
                        .foregroundColor(Color(white: 151 / 255))
                }
                .padding()
                .frame(height: 135)
            }
        }
    }

    /// The publications a user is not following
    private var morePublicationsSection: some View {
        Section(
            header: Header("More publications")
                .padding([.leading, .top, .trailing])
                .padding(.bottom, 6)
        ) {
            switch state {
            case .loading:
                VStack {
                    ForEach(0..<4) { _ in
                        MorePublicationRow.Skeleton()
                            .padding(.bottom, 15)
                    }
                }
            case .reloading(let results), .results(let results):
                VStack {
                    ForEach(results.morePublications) { publication in
                        NavigationLink(destination: PublicationDetail(navigationSource: .morePublications, publication: publication)) {
                            MorePublicationRow(publication: publication, navigationSource: .morePublications)
                                .padding(.bottom, 15)
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            RefreshableScrollView(onRefresh: { done in
                switch state {
                case .loading, .reloading:
                    return
                case .results(let results):
                    state = .reloading(results)
                    self.fetch(done)
                }
            }) {
                VStack {
                    followedPublicationsSection
                    Spacer()
                        .frame(height: 16)
                    morePublicationsSection
                }
            }
            .disabled(state.shouldDisableScroll)
            .padding(.top)
            .background(Color.volume.backgroundGray)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    BubblePeriodText("Publications")
                        .font(.begumMedium(size: 28))
                        .offset(y: 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetch()
            }
        }
    }
}

extension PublicationList {
    typealias Results = (
        followedPublications: [Publication],
        morePublications: [Publication]
    )
    private enum PublicationListState {
        case loading
        case reloading(Results)
        case results(Results)
        
        var shouldDisableScroll: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
    }
}

struct PublicationList_Previews: PreviewProvider {
    static var previews: some View {
        PublicationList()
    }
}
