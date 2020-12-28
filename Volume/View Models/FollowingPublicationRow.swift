//
//  PublicationRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI

/// `FollowingPublicationRow` displays the images and name of a publication a user is currently following
struct FollowingPublicationRow: View {
    let publication: Publication
        
    var body: some View {
        VStack(spacing: 5) {
            if let url = publication.profileImageURL {
                WebImage(url: url)
                    .resizable()
                    .grayBackground()
                    .clipShape(Circle())
                    .frame(width: 75, height: 75)
                    .shadow(color: Color(white: 0, opacity: 0.1), radius: 5)
                    .transition(.fade(duration: 0.5))
            } else {
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 75, height: 75)
                    .shadow(color: Color(white: 0, opacity: 0.1), radius: 5)
            }
            Text(publication.name)
                .font(.begumMedium(size: 12))
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(width: 90, height: 135)
    }
}

extension FollowingPublicationRow {
    struct Skeleton: View {
        var body: some View {
            VStack(spacing: 5) {
                SkeletonView()
                    .clipShape(Circle())
                    .shadow(color: Color(white: 0, opacity: 0.1), radius: 5)
                    .frame(width: 75, height: 75)
                SkeletonView()
                    .frame(width: 65, height: 14)
                Spacer()
            }
            .frame(width: 90, height: 135)
        }
    }
}

//struct FollowingPublicationRow_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowingPublicationRow(
//            publication: Publication(
//                description: "CU",
//                name: "CUNooz",
//                id: "sdfsdf",
//                imageURL: nil,
//                recent: "Sandpaper Tastes Like What?!"
//            )
//        )
//    }
//}
