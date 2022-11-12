//
//  FollowingMagazineCell.swift
//  Volume
//
//  Created by Justin Ngai on 6/3/2022.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI
import PDFKit

/// `MagazineCell` displays the images and name of a publication a user is currently following
struct MagazineCell: View {

    let magazine: Magazine

    var body: some View {
        VStack(alignment: .leading) {
            if let url = magazine.pdfUrl {
                SimplePDFView(pdfDoc: PDFDocument(url: url)!)
                    .frame(width: 150, height: 220)
                    .scaledToFill()
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 4, y: 4)
                    .disabled(true)
            }

            Spacer()
                .frame(height: 12)

            Text(magazine.publication.name)
                .font(.newYorkRegular(size: 12))
                .foregroundColor(.black)

            Spacer()
                .frame(height: 2)

            Text(magazine.title)
                .font(.helveticaBold(size: 14))
                .foregroundColor(.black)

            Spacer()
                .frame(height: 1)

            Text("\(magazine.date.fullString) • \(magazine.shoutouts) shout-outs")
                .font(.helveticaRegular(size: 10))
                .foregroundColor(.volume.lightGray)
        }
        .frame(width: 152, height: 278)
    }
}

extension MagazineCell {
    struct Skeleton: View {
        var body: some View {
            VStack(alignment: .leading) {
                SkeletonView()
                    .frame(width: 150, height: 220)

                Spacer()
                    .frame(height: 12)

                SkeletonView()
                    .frame(width: 126, height: 14)

                Spacer()
                    .frame(height: 2)

                SkeletonView()
                    .frame(width: 150, height: 20)

                Spacer()
                    .frame(height: 1)

                HStack(spacing: 0) {
                    SkeletonView()
                        .frame(width: 33, height: 10)
                    Text(" • ")
                        .font(.helveticaRegular(size: 10))
                        .foregroundColor(.volume.veryLightGray)
                    SkeletonView()
                        .frame(width: 70, height: 10)
                }
            }
            .frame(width: 152, height: 278)
        }
    }
}
