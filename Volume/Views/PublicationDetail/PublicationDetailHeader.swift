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
    private let iconGray = Color(white: 196 / 255)

    let publication: Publication
    
    private var isFollowed: Bool {
        userData.isPublicationFollowed(publication)
    }

    private var shoutouts: Int {
        max(publication.shoutouts, userData.shoutoutsCache[publication.id, default: 0])
    }
    
    private func findUrl(for social: String) -> URL? {
        publication.socials?.first(where: { $0.name == social })?.url
    }

    private var externalLinks: some View {
        HStack {
            if let url = findUrl(for: "instagram") {
                Image("instagram")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(iconGray)
                MediaText(title: "Instagram", url: url)
            }
            if let url = findUrl(for: "facebook") {
                Image("facebook")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(iconGray)
               MediaText(title: "Facebook", url: url)
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
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        userData.togglePublicationFollowed(publication)
                    }
                }) {
                    Text(isFollowed ? "Followed" : "＋ Follow")
                        .font(.helveticaBold(size: 12))
                        .frame(width: 85, height: 30)
                        .background(isFollowed ? Color.volume.orange : Color.volume.buttonGray)
                        .foregroundColor(isFollowed ? Color.volume.buttonGray : Color.volume.orange)
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
    }
}

struct MediaText: View {
    let title: String!
    let url: URL!
    
    var body: some View {
        Link(title, destination: url)
            .font(.helveticaRegular(size: 12))
            .foregroundColor(Color.volume.orange)
            .padding(.trailing, 10)
    }
}
