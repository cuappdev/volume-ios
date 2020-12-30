//
//  PublicationHeader.swift
//  Volume
//
//  Created by Daniel Vebman on 12/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationHeader: View {
    @State private var didAddPublication = false
    private let iconGray = Color(white: 196 / 255)

    let publication: Publication
    
    /// Computes the total number of shout-outs on all articles by `publication`
    private var shoutOuts: Int {
        publication.shoutouts
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
                    self.didAddPublication.toggle()
                }) {
                    Text(didAddPublication ? "Followed" : "＋ Follow")
                        .font(.helveticaBold(size: 12))
                        .frame(width: 85, height: 30)
                        .background(didAddPublication ? Color.volume.orange : Color.volume.buttonGray)
                        .foregroundColor(didAddPublication ? Color.volume.buttonGray : Color.volume.orange)
                        .cornerRadius(5)
                }
                .buttonStyle(PlainButtonStyle())
            }
            // TODO: `publication.articles.count` articles
            Text("\(0) articles  •  \(shoutOuts) shout-outs")
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
