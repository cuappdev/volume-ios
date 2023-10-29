//
//  MagazineCell.swift
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
    @EnvironmentObject private var userData: UserData

    let magazine: Magazine

    private struct Constants {
        static let imageSize: CGSize = CGSize(width: 150, height: 220)
        static let pdfviewOpacity: CGFloat = 0.2
        static let pdfviewRadius: CGFloat = 8
        static let pdfviewX: CGFloat = 4
        static let pdfviewY: CGFloat = 4
        static let pdfPubPadding: CGFloat = 12
        static let pubTitlePadding: CGFloat = 2
        static let titleInfoPadding: CGFloat = 1
        static let pubTextSize: CGFloat = 12
        static let magazineTitleSize: CGFloat = 14
        static let infoTextSize: CGFloat = 10

        static let cellWidth: CGFloat = 152
        static let cellHeight: CGFloat = 278
    }

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if let url = magazine.imageUrl {
                    WebImage(url: url)
                        .resizable()
                        .grayBackground()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
                        .clipped()
                }
            }
            .scaledToFill()
            .shadow(
                color: Color.black.opacity(Constants.pdfviewOpacity),
                radius: Constants.pdfviewRadius,
                x: Constants.pdfviewX,
                y: Constants.pdfviewY
            )
            .disabled(true)

            Spacer()
                .frame(height: Constants.pdfPubPadding)

            Text(magazine.publication.name)
                .font(.newYorkRegular(size: Constants.pubTextSize))
                .foregroundColor(.black)

            Spacer()
                .frame(height: Constants.pubTitlePadding)

            Text(magazine.title)
                .font(.helveticaBold(size: Constants.magazineTitleSize))
                .foregroundColor(.black)

            Spacer()
                .frame(height: Constants.titleInfoPadding)

            // swiftlint:disable:next line_length
            Text("\(magazine.date.fullString) • \(max(magazine.shoutouts, userData.shoutoutsCache[magazine.id, default: 0])) shout-outs")
                .font(.helveticaRegular(size: Constants.infoTextSize))
                .foregroundColor(.volume.lightGray)
        }
        .frame(width: Constants.cellWidth, height: Constants.cellHeight)
    }
}

extension MagazineCell {
    struct Skeleton: View {
        var body: some View {
            VStack(alignment: .leading) {
                SkeletonView()
                    .frame(width: Constants.imageSize.width, height: Constants.imageSize.height)

                Spacer()
                    .frame(height: Constants.pdfPubPadding)

                SkeletonView()
                    .frame(width: 126, height: 14)

                Spacer()
                    .frame(height: Constants.pubTitlePadding)

                SkeletonView()
                    .frame(width: 150, height: 20)

                Spacer()
                    .frame(height: Constants.titleInfoPadding)

                HStack(spacing: 0) {
                    SkeletonView()
                        .frame(width: 33, height: 10)
                    Text(" • ")
                        .font(.helveticaRegular(size: Constants.infoTextSize))
                        .foregroundColor(.volume.veryLightGray)
                    SkeletonView()
                        .frame(width: 70, height: 10)
                }
            }
            .frame(width: Constants.cellWidth, height: Constants.cellHeight)
            .shimmer(.largeShimmer())
        }
    }
}
