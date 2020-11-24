//
//  PublicationList.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationList: View {
    // The publications a user is following
    private var followedPublications: some View {
        Section {
            Header(text: "FOLLOWING")
                .padding(.top)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(publicationsData) { publication in
                        NavigationLink(destination: PublicationDetail(publication: publication)) {
                            FollowingPublicationRow(publication: publication)
                        }
                    }
                }
                .padding([.top, .leading, .trailing], 10)
            }
        }
    }
    
    // The publications a user is not following
    private var notFollowedPublications: some View {
        Section {
            Header(text: "MORE PUBLICATIONS")
                .padding(.bottom)
            ForEach(publicationsData) { publication in
                NavigationLink(destination: PublicationDetail(publication: publication)) {
                    MorePublicationRow(publication: publication)
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing)
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                followedPublications
                notFollowedPublications
            }
            .navigationTitle("Publications.")
        }
    }
}

// TODO: replace w/ Volume specific design
private struct Header : View {
    @State var text: String
    
    var body : some View {
        HStack {
            Text(text)
                .padding(.leading)
            Spacer()
        }
    }
}

struct PublicationList_Previews: PreviewProvider {
    static var previews: some View {
        PublicationList()
    }
}
