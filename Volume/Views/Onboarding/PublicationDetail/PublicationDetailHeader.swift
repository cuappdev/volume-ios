//
//  PublicationDetailHeader.swift
//  Volume
//
//  Created by Daniel Vebman on 12/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import SwiftUI

struct PublicationDetailHeader: View {
    @EnvironmentObject private var userData: UserData
    @State private var hasOddNumberOfTaps = false
    private let iconGray = Color(white: 196 / 255)

    let navigationSource: NavigationSource
    let publication: Publication
    // Takes into account any new user taps of the following button
    private var isFollowed: Bool {
        userData.isPublicationFollowed(publication) != hasOddNumberOfTaps
    }
    private var shoutouts: Int {
        max(publication.shoutouts, userData.shoutoutsCache[publication.id, default: 0])
    }
    private var validSocials: [String: String] {
        ["insta": "Instagram", "facebook": "Facebook"]
    }

    private var externalLinks: some View {
        HStack {
            ForEach(publication.socials, id: \.name) { social in
                if let title = validSocials[social.name] {
                    Image(social.name)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(iconGray)
                    MediaText(title: title, url: social.url)
                }
            }
            if let url = publication.websiteUrl {
                Image(systemName: "link")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(iconGray)
                MediaText(title: url.host ?? "Website", url: url)
            }
        }
        .padding(.top, 15)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(publication.name)
                    .font(.begumMedium(size: 18))
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Button(action: {
                    hasOddNumberOfTaps.toggle()
                }, label: {
                    Text(isFollowed ? "Following" : "+  Follow")
                        .font(.latoBold(size: 12))
                        .padding([.top, .bottom], 8)
                        .padding([.leading, .trailing], 18)
                })
                .foregroundColor(isFollowed ? Color.volume.buttonGray: Color.volume.orange)
                .background(
                    isFollowed ?
                        AnyView(RoundedRectangle(cornerRadius: 10).fill(Color.volume.orange)) :
                        AnyView(RoundedRectangle(cornerRadius: 10).stroke(Color.volume.orange, lineWidth: 1.5))
                )
            }
            Text("\(publication.numArticles) articles  •  \(shoutouts) shout-outs")
                .font(.latoRegular(size: 12))
                .foregroundColor(Color(white: 151 / 255))
                .padding([.bottom, .top], 8)
            Text(publication.bio)
                .font(.latoRegular(size: 14))
                .fixedSize(horizontal: false, vertical: true)
            externalLinks
        }
        .padding([.leading, .trailing])
        .onDisappear {
            if hasOddNumberOfTaps {
                userData.togglePublicationFollowed(publication)
                AppDevAnalytics.log(
                    userData.isPublicationFollowed(publication) ?
                        VolumeEvent.followPublication.toEvent(.publication, value: publication.id, navigationSource: navigationSource) :
                        VolumeEvent.unfollowPublication.toEvent(.publication, value: publication.id, navigationSource: navigationSource)
                )
            }
        }
    }
}

struct MediaText: View {
    let title: String
    let url: URL
    
    var body: some View {
        Link(title, destination: url)
            .font(.latoRegular(size: 12))
            .foregroundColor(Color.volume.orange)
            .padding(.trailing, 10)
            .lineLimit(1)
    }
}
