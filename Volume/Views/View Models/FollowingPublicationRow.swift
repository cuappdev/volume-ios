//
//  PublicationRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// `FollowingPublicationRow` displays the images and name of a publication a user is currently following
struct FollowingPublicationRow: View {
    let publication: Publication
        
    var body: some View {
        VStack {
            Image(publication.image)
                .resizable()
                .clipShape(Circle())
                .shadow(color: Color(white: 0, opacity: 0.1), radius: 5)
                .frame(width: 85, height: 85)
            Text(publication.name)
                .font(Font.begumMedium(size: 12))
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .offset(y: -5)
            Spacer()
        }
        .frame(width: 90, height: 135)
    }
}

struct FollowingPublicationRow_Previews: PreviewProvider {
    static var previews: some View {
        FollowingPublicationRow(publication: publicationsData[0])
    }
}
