//
//  PublicationHeader.swift
//  Volume
//
//  Created by Cameron Russell on 12/28/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationHeader: View {
    @State private var didAddPublication = false
    private let iconGray = Color(white: 196 / 255)

    let publication: Publication
    
    /// Computes the total number of shout-outs on all articles by `publication`
    private var shoutOuts: Int {
        publication.articles.map(\.shoutOuts).reduce(0, +)
    }

    func link(for social: String, image: String, isUnderlined: Bool) -> some View {
        return (
            Section {
                Button(
                    action: {},
                    label: {
                        Image(image)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(iconGray)
                })
                Text(social)
                    .font(.helveticaRegular(size: 12))
                    .foregroundColor(Color.volume.orange)
                    .padding(.trailing, 10)
            }
        )
    }
    
    private var externalLinks: some View {
        HStack {
            if let _ = publication.socials["Instagram"] {
                link(for: "Instagram", image: "instagram", isUnderlined: false)
            }
            if let _ = publication.socials["Facebook"] {
                link(for: "Facebook", image: "facebook", isUnderlined: false)
            }
            if let website = publication.socials["Website"] {
                link(for: website, image: "link", isUnderlined: true)
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
                    didAddPublication.toggle()
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
            Text("\(publication.articles.count) articles  •  \(shoutOuts) shout-outs")
                .font(.helveticaRegular(size: 12))
                .foregroundColor(Color(white: 151 / 255))
                .padding([.bottom, .top], 8)
            Text(publication.description)
                .font(.helveticaRegular(size: 14))
            externalLinks
        }
        .padding([.leading, .trailing])
    }
}

struct PublicationHeader_Previews: PreviewProvider {
    static var previews: some View {
        PublicationHeader(publication: publicationsData[0])
    }
}
