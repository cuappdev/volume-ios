//
//  PublicationRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// `MorePublicationRow` displays the basis information about a publications the user is not currently following
struct MorePublicationRow: View {
    let publication: Publication
    let onToggleFollowing: (Publication) -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            Image(publication.image)
                .resizable()
                .clipShape(Circle())
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(publication.name)
                    .font(.begumMedium(size: 18))
                    .foregroundColor(.black)
                Text(publication.description)
                    .font(.helveticaRegular(size: 12))
                    .foregroundColor(Color(white: 151 / 255))
                    .truncationMode(.tail)
                    .lineSpacing(4)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Text("|")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(white: 225 / 255))
                    Text("\"\(publication.recent)\"")
                        .font(.helveticaRegular(size: 12))
                        .foregroundColor(.black)
                }
                .padding(.top, 2)
            }
            
            Spacer()
            
            Button(action: {
                self.onToggleFollowing(self.publication)
            }) {
                Image(publication.isFollowing ? "followed" : "follow")
            }
        }.padding([.leading, .trailing])
    }
}

struct MorePublicationRow_Previews: PreviewProvider {
    static var previews: some View {
        MorePublicationRow(publication: publicationsData[0]) { publication in
            
        }
    }
}
