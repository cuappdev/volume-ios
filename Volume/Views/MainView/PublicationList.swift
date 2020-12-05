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
    @State private var followedPublications: [Publication] = []
    @State private var morePublications: [Publication] = []
    @State private var cancellableQuery: AnyCancellable?
    @EnvironmentObject private var userData: UserData
    
    private func fetch() {
        let publications = followedPublications + morePublications
        guard publications.count == 0 else {
            followedPublications = publications.filter(\.isFollowed)
            morePublications = publications.filter { !$0.isFollowed }
            return
        }
        
        cancellableQuery = Network.shared.apollo.fetch(query: GetAllPublicationsQuery())
            .map { data in data.publications.compactMap { $0 } }
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { value in
                let publications = [Publication](value)
                followedPublications = publications.filter(\.isFollowed)
                morePublications = publications.filter { !$0.isFollowed }
            })
    }
    
    /// The publications a user is following
    private var followedPublicationsSection: some View {
        Section(header: Header("Following").padding(.bottom, -12)) {
            if followedPublications.count > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(followedPublications) { publication in
                            NavigationLink(destination: PublicationDetail(publication: publication)) {
                                FollowingPublicationRow(publication: publication)
                            }
                        }
                    }
                    .padding([.leading, .trailing], 10)
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
        Section(header: Header("More publications").padding(.bottom, -12)) {
            LazyVStack {
                // TODO: Replace with real data.
                ForEach(morePublications) { publication in
                    NavigationLink(destination: PublicationDetail(publication: publication)) {
                        MorePublicationRow(publication: publication)
                            .padding(.bottom, 15)
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                followedPublicationsSection
                Spacer()
                    .frame(height: 16)
                morePublicationsSection
            }
            .background(Color.volume.backgroundGray)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    BubblePeriodText("Publications")
                        .font(.begumMedium(size: 28))
                        .offset(y: 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: fetch)
    }
}

struct PublicationList_Previews: PreviewProvider {
    static var previews: some View {
        PublicationList()
    }
}
