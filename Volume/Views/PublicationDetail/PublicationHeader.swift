//
//  PublicationHeader.swift
//  Volume
//
//  Created by Daniel Vebman on 12/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationHeader: View {
    @EnvironmentObject private var userData: UserData
    private let iconGray = Color(white: 196 / 255)

    let publication: Publication
    
    private var isFollowed: Bool {
        userData.isPublicationFollowed(publication)
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
            HStack {
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
                        .foregroundColor(
                            isFollowed ? Color.volume.buttonGray : Color.volume.orange
                        )
                        .cornerRadius(5)
                }
                .buttonStyle(PlainButtonStyle())
            }
            // TODO: `publication.articles.count` articles
            Text("\(0) articles  •  \(publication.shoutouts) shout-outs")
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
