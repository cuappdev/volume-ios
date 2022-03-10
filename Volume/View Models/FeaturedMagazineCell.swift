//
//  FollowingMagazineCell.swift
//  Volume
//
//  Created by Justin Ngai on 6/3/2022.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI

/// `FeaturedMagazineRow` displays the images and name of a publication a user is currently following
struct FeaturedMagazineCell: View {

    // TODO: Restore when backend setup
    // let magazine: Magazine
    // let largeFont: Bool

    // TODO: Remove test values when backend setup
    struct dummyMagazine {
        var id: String
        var title: String
        var date: Date
        var coverUrl: URL?
        var publication: dummyPublication
        var shoutouts: Int
        var magazineUrl: URL?
    }
    struct dummyPublication {
        var name: String
    }

    let magazine = dummyMagazine(id: "", title: "Artifacts For All", date: Date.distantPast, coverUrl:  URL(string: "https://www.cs.cornell.edu/ken/Photo%20of%20Me.jpg"), publication: dummyPublication(name: "Cornell"), shoutouts: 100, magazineUrl: nil)


    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: magazine.coverUrl)
                .resizable()
                .grayBackground()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 220)
                .clipped()
                .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 8, x: 4, y: 4)
            Spacer()
                .frame(height: 12)
            Text(magazine.publication.name)
                .font(.begumRegular(size: 12))
                .foregroundColor(Color.black)
            Spacer()
                .frame(height: 2)
            Text(magazine.title)
                .font(.helveticaBold(size: 14))
                .foregroundColor(Color.black)
            Spacer()
                .frame(height: 1)
            Text("\(magazine.date.fullString) • \(magazine.shoutouts) shout-outs")
                .font(.latoRegular(size: 10))
                .foregroundColor(Color.volume.lightGray)
        }
        .frame(width: 152, height: 278)
    }
}

extension FeaturedMagazineCell {
    struct Skeleton: View {
        var body: some View {
            VStack(spacing: 5) {
                SkeletonView()
                    .clipShape(Circle())
                    .shadow(color: Color(white: 0, opacity: 0.1), radius: 5)
                    .frame(width: 75, height: 75)
                    .padding(.top, 4)
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
