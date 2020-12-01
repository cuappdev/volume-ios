//
//  PublicationList.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationList: View {
    /// The publications a user is following
    private var followedPublications: some View {
        Section(header: header("Following")) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(publicationsData) { publication in
                        NavigationLink(destination: PublicationDetail(publication: publication)) {
                            FollowingPublicationRow(publication: publication)
                        }
                    }
                }
                .padding([.leading, .trailing], 10)
            }
        }
    }
    
    /// The publications a user is not following
    private var notFollowedPublications: some View {
        Section(header: header("More publications")) {
            VStack {
                ForEach(0..<15) { i in
                    let publication = publicationsData[i % publicationsData.count]
                    NavigationLink(destination: PublicationDetail(publication: publication)) {
                        MorePublicationRow(publication: publication, onToggleFollowing: onToggleFollowing)
                            .padding(.bottom, 15)
                    }
                }
            }
        }
    }
    
    /// Toggle following this Publication
    private func onToggleFollowing(publication: Publication) {
        
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                followedPublications
                Spacer()
                    .frame(height: 40)
                notFollowedPublications
            }
            .padding(.top, 18)
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
    }
}

extension PublicationList {
    private func header(_ text: String) -> some View {
        UnderlinedText(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
    }
}

struct PublicationList_Previews: PreviewProvider {
    static var previews: some View {
        PublicationList()
    }
}
