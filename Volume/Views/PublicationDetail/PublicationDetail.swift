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

                Header("Articles")
//                LazyVStack {
//                    ForEach(Array(Set(publication.articles))) { article in
//                        ArticleRow(article: article, showsPublicationName: false)
//                            .padding([.bottom, .leading, .trailing])
//                    }
//                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
        .gesture(DragGesture().updating($dragOffset, body: { value, _, _ in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
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

//struct PublicationDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PublicationDetail(publication: publicationsData[0])
//    }
//}
