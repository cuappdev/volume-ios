//
//  PublicationRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// `MorePublicationRow`displays the basis information about a publications the user is not currently following
struct MorePublicationRow: View {
    @State private var didAddPublication = false
    
    let publication: Publication
    
    var body: some View {
        HStack {
            VStack {
                Image(publication.image)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                    .padding(.leading)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Creme de Cornell")
                    .font(.custom("Futura-Medium", size: 18))
                    .foregroundColor(.black)
                Text(publication.description)
                    .font(.custom("Helvetica-Regular", size: 12))
                    .foregroundColor(Color(white: 151/255))
                    .truncationMode(.tail)
                    .lineSpacing(4)
                    .lineLimit(2)
                HStack {
                    Text("|")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(white: 225 / 255))
                    Text("\"\(publication.recent)\"")
                        .font(.custom("Helvetica-Regular", size: 12))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .padding(.top, 2)
                Spacer()
            }
            
            Spacer()
            
            VStack {
                Button(action: {
                    self.didAddPublication.toggle()
                    // TODO: Add to list of subscribers
                }) {
                    Image(didAddPublication ? "followed" : "follow")
                }
                Spacer()
            }
        }
    }
}

struct MorePublicationRow_Previews: PreviewProvider {
    static var previews: some View {
        MorePublicationRow(publication: publicationsData[0])
        MorePublicationRow(publication: publicationsData[1])
    }
}
