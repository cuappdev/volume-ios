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
    let publication: Publication
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                Header(text: "Articles")
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(Array(Set(articleData))) { article in  // TODO: replace with publication's articles
                            ArticleRow(article: article)
                                .padding([.bottom, .leading, .trailing])
                        }
                    }
                }
            }
            .background(Color.volume.backgroundGray)
            .navigationBarTitleDisplayMode(.inline)
        }
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
