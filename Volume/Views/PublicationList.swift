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
            header("Following")
                .padding(.top, 18)
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
            header("More publications")
            ForEach(publicationsData) { publication in
                NavigationLink(destination: PublicationDetail(publication: publication)) {
                    MorePublicationRow(publication: publication)
                        .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                followedPublications
                Spacer()
                    .frame(height: 48)
                notFollowedPublications
            }
            .background(Color.volume.backgroundGray)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    BubblePeriodText("Publications")
                        .font(.begumMedium(size: 24))
                        .offset(y: 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension PublicationList {
    func header(_ text: String) -> some View {
        HStack {
            UnderlinedText(text)
                .font(.begumMedium(size: 20))
            Spacer()
        }
        .padding(.leading)
    }
}

struct PublicationList_Previews: PreviewProvider {
    static var previews: some View {
        PublicationList()
    }
}
