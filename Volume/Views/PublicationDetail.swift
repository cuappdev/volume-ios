//
//  PublicationDetail.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// `PublicationDetail` displays detailed information about a publication
struct PublicationDetail: View {
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let publication: Publication
    
    private var backgroundImage: some View {
        ZStack {
            GeometryReader { geometry in
                Image("cremeCoverImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 140)
            }
            HStack {
                VStack(alignment: .leading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                       // TODO: update following list
                    }) {
                        Image("backarrow")
                            .padding(EdgeInsets(top: 55, leading: 20, bottom: 0, trailing: 0))
                    }
                    
                    Spacer()
                    Image("iceCream")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .scaledToFill()
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .shadow(color: Color.volume.shadowBlack, radius: 5, x: 0, y: 0)
                        .padding(.leading, 16)
                }
                
                Spacer()
            }
        }
        .frame(height: 156)
    }
    
    var body: some View {
        Section {
            ScrollView(showsIndicators: false) {
                backgroundImage
                
                PublicationHeader(publication: publication)
                    .padding(.bottom)
                
                Divider()
                    .background(Color(white: 238 / 255))
                    .frame(width: 100)

                Header(text: "Articles")
                LazyVStack {
                    ForEach(Array(Set(publication.articles))) { article in
                        ArticleRow(article: article, showsPublicationName: false)
                            .padding([.bottom, .leading, .trailing])
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
    }
}

private struct PublicationHeader: View {
    @State private var didAddPublication = false
    private let iconGray = Color(white: 196 / 255)

    let publication: Publication
    
    /// Computes the total number of shout-outs on all articles by `publication`
    private var shoutOuts: Int {
        publication.articles.map({ $0.shoutOuts }).reduce(0, +)
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

//struct PublicationDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PublicationDetail(
//            publication: Publication(
//                description: "A publication bringing you only the collest horse facts.",
//                name: "Guac",
//                id: "asdfsf39201sd923k",
//                imageURL: nil,
//                recent: "Horses love to swim"
//            )
//        )
//    }
//}
