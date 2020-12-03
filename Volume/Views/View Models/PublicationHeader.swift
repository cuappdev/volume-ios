//
//  PublicationHeader.swift
//  Volume
//
//  Created by Cameron Russell on 12/2/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationHeader: View {
    let publication: Publication
    
    var body: some View {
        VStack {
            Text("\(publication.articles.count) articles * \(publication.shoutOuts) shout-outs")
                .font(.helveticaRegular(size: 12))
            Text(publication.description)
                .font(.helveticaRegular(size: 14))
                .lineLimit(nil)
                .padding()
            HStack {
                if let insta = publication.instagram {
                    
                }
                if let facebook = publication.facebook {
                    
                }
                if let website = publication.website {
                    
                }
            }
        }
    }
}

struct PublicationHeader_Previews: PreviewProvider {
    static var previews: some View {
        PublicationHeader()
    }
}
