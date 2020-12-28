//
//  PublicationHeader.swift
//  Volume
//
//  Created by Cameron Russell on 12/2/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationHeader: View {
    @State private var didAddPublication = false
    private let iconGray = Color(white: 196 / 255)
    
    let publication: Publication
    
    private var shoutOuts: Int {
        publication.articles.map({ $0.shoutOuts }).reduce(0, +)
    }
    
    private var background: some View {
        ZStack {
            GeometryReader { geo in
                Image("cremeCoverImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: 140)
            }
            HStack {
                VStack(alignment: .leading) {
                    Spacer()
                    Image("iceCream")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .scaledToFill()
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .shadow(color: Color.volume.shadowBlack, radius: 5, x: 0, y: 0)
                }
                .padding(.leading, 16)
                
                Spacer()
            }
        }
        .frame(height: 156)
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
        background
        VStack(alignment: .leading) {
            HStack {
                Text(publication.name)
                    .font(.begumMedium(size: 18))
                
                Spacer()
                
                Button(action: {
                    self.didAddPublication.toggle()
                    // TODO: Add to list of subscribers
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
                .lineLimit(nil)
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
