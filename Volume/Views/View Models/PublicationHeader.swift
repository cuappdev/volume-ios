//
//  PublicationHeader.swift
//  Volume
//
//  Created by Cameron Russell on 12/2/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationHeader: View {
    private let iconGray = Color(white: 196 / 255)
    
    let publication: Publication
    
    private var shoutOuts: Int {
        publication.articles.map({ $0.shoutOuts }).reduce(0, +)
    }
    
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
            }
            if let _ = publication.socials["Facebook"] {
                Image("facebook")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(iconGray)
                Text("Facebook")
                    .font(.helveticaRegular(size: 12))
                    .foregroundColor(Color.volume.orange)
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
        .padding([.bottom, .top], 15)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Image("cremeCoverImage")
                HStack {
                    ZStack {  // Note: SwiftUI was adding unwanted sapcing around the image; this is a workaround
                        Circle()
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                        Image(publication.image)
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    Spacer()
                }
            }
            HStack {
                Text(publication.name)
                    .font(.begumMedium(size: 18))
                
                Spacer()
                
                Button(action: {
                    // TODO: Add to list of subscribers
                }) {
                    Text("+ Follow")
                }
            }
            Text("\(publication.articles.count) articles • \(shoutOuts) shout-outs")
                .font(.helveticaRegular(size: 12))
                .foregroundColor(Color(white: 151 / 255))
                .padding([.bottom, .top], 15)
            Text(publication.description)
                .font(.helveticaRegular(size: 14))
                .lineLimit(nil)
            externalLinks
        }
    }
}

struct PublicationHeader_Previews: PreviewProvider {
    static var previews: some View {
        PublicationHeader(publication: publicationsData[0])
    }
}
