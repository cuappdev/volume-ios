//
//  PublicationDetailHeader.swift
//  Volume
//
//  Created by Daniel Vebman on 12/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationDetailHeader: View {
    @EnvironmentObject private var userData: UserData
    @State private var hasOddNumberOfTaps = false
    private let iconGray = Color(white: 196 / 255)

    let publication: Publication
    
    // Whether the publication is followed at the time this view is displayed
    private var isFollowed: Bool {
        userData.isPublicationFollowed(publication)
    }

    private var shoutouts: Int {
        max(publication.shoutouts, userData.shoutoutsCache[publication.id, default: 0])
    }
    
    // Takes into account any new user taps of the following button
    private var isFollowedAdjusted: Bool {
        isFollowed && !hasOddNumberOfTaps || !isFollowed && hasOddNumberOfTaps
    }

    // TODO: refactor
    private var externalLinks: some View {
        HStack {
            if let _ = publication.socials["Instagram"] {
                Image("instagram")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(iconGray)
                Text("Instagram")
                    .font(.helveticaRegular(size: 12))
                    .foregroundColor(Color.volume.orange)
                    .padding(.trailing, 10)
            }
            if let _ = publication.socials["Facebook"] {
                Image("facebook")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(iconGray)
                Text("Facebook")
                    .font(.helveticaRegular(size: 12))
                    .foregroundColor(Color.volume.orange)
                    .padding(.trailing, 10)
            }
            if let website = publication.socials["Website"] {
                Image(systemName: "link")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(iconGray)
                Text(website)
                    .font(.helveticaRegular(size: 12))
                    .foregroundColor(Color.volume.orange)
                    .underline()
            }
        }
        .padding(.top, 15)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(publication.name)
                    .font(.begumMedium(size: 18))
                    .frame(idealHeight: 23, maxHeight: .infinity, alignment: .leading)
                
                Spacer()
                
                Button(action: {
                    hasOddNumberOfTaps.toggle()
                }) {
                    Text(isFollowedAdjusted ? "Followed" : "＋ Follow")
                        .font(.helveticaBold(size: 12))
                        .frame(width: 85, height: 30)
                        .background(isFollowedAdjusted ? Color.volume.orange : Color.volume.buttonGray)
                        .foregroundColor(isFollowedAdjusted ? Color.volume.buttonGray : Color.volume.orange)
                        .cornerRadius(5)
                }
                .buttonStyle(PlainButtonStyle())
            }
            Text("\(publication.numArticles) articles  •  \(shoutouts) shout-outs")
                .font(.helveticaRegular(size: 12))
                .foregroundColor(Color(white: 151 / 255))
                .padding([.bottom, .top], 8)
            Text(publication.bio)
                .font(.helveticaRegular(size: 14))
            externalLinks
        }
        .padding([.leading, .trailing])
        .onDisappear {
            if hasOddNumberOfTaps {
                userData.togglePublicationFollowed(publication)
            }
        }
    }
}
