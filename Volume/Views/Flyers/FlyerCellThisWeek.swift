//
//  FlyerCellThisWeek.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FlyerCellThisWeek: View {
    
    // MARK: - Properties
    
    let flyer: Flyer
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonSize: CGFloat = 15
        static let categoryFont: Font = .helveticaRegular(size: 10)
        static let categoryHorizontalPadding: CGFloat = 16
        static let categoryVerticalPadding: CGFloat = 4
        static let cellHeight: CGFloat = 344
        static let cellWidth: CGFloat = 256
        static let dateFont: Font = .helveticaRegular(size: 12)
        static let imageHeight: CGFloat = 256
        static let imageWidth: CGFloat = 256
        static let locationFont: Font = .helveticaRegular(size: 12)
        static let organizationNameFont: Font = .newYorkMedium(size: 10)
        static let spacing: CGFloat = 4
        static let titleFont: Font = .newYorkMedium(size: 20)
    }
    
    // MARK: - UI
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            imageFrame
            organizationName
            flyerTitle
            flyerDate
            flyerLocation
        }
        .frame(width: Constants.cellWidth, height: Constants.cellHeight)
    }
    
    private var imageFrame: some View {
        ZStack(alignment: .topLeading) {
            // TODO: Remove temporary image holder
            AsyncImage(
                url: URL(string: flyer.imageURL),
                content: { image in
                    image.resizable()
                        .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                },
                placeholder: {
                    SkeletonView()
                        .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                }
            )
            
            Text(Organization.contentTypeString(
                    type: flyer.organization.contentType)
                )
                .padding(.init(
                    top: Constants.categoryVerticalPadding,
                    leading: Constants.categoryHorizontalPadding,
                    bottom: Constants.categoryVerticalPadding,
                    trailing: Constants.categoryHorizontalPadding
                ))
                .font(Constants.categoryFont)
                .foregroundColor(Color.white)
                .background(Color.volume.orange)
                .clipShape(Capsule())
                .padding([.top, .leading], 8)
        }
    }
    
    private var bookmarkButton: some View {
        Button {
            Haptics.shared.play(.light)
            // TODO: Bookmark Flyer
        } label: {
            Image.volume.bookmark
                .resizable()
                .foregroundColor(.volume.orange)
                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
        }
    }

    private var shareButton: some View {
        Button {
            Haptics.shared.play(.light)
            // TODO: Share Flyer
        } label: {
            Image.volume.share
                .resizable()
                .foregroundColor(.black)
                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
        }
    }
    
    private var organizationName: some View {
        HStack(alignment: .top) {
            Text(flyer.organization.name)
                .font(Constants.organizationNameFont)
                .lineLimit(1)
            
            Spacer()
            
            bookmarkButton
            shareButton
        }
        .padding(.top, Constants.spacing)
        .padding(.bottom, -Constants.spacing)
    }
    
    private var flyerTitle: some View {
        Text(flyer.title)
            .font(Constants.titleFont)
            .lineLimit(1)
    }
    
    private var flyerDate: some View {
        HStack {
            Image.volume.calendar
                .foregroundColor(Color.black)
            
            Text(flyer.date.flyerDateString)
                .font(Constants.dateFont)
                .padding(.trailing, 2 * Constants.spacing)
                .lineLimit(1)
            
            Text(flyer.date.flyerTimeString)
                .font(Constants.dateFont)
                .lineLimit(1)
        }
    }
    
    private var flyerLocation: some View {
        HStack {
            Image.volume.location
                .foregroundColor(Color.black)
            
            Text(flyer.location)
                .font(Constants.locationFont)
                .lineLimit(1)
        }
    }
    
}

extension FlyerCellThisWeek {
    
    struct Skeleton: View {
        var body: some View {
            VStack(alignment: .leading) {
                SkeletonView()
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)

                SkeletonView()
                    .frame(width: 130, height: 15)

                SkeletonView()
                    .frame(width: 200, height: 20)

                SkeletonView()
                    .frame(width: 180, height: 15)

                SkeletonView()
                    .frame(width: 100, height: 15)
            }
            .frame(width: Constants.cellWidth, height: Constants.cellHeight)
        }
    }
    
}

// MARK: Uncomment below if needed

//struct FlyerCellThisWeek_Previews: PreviewProvider {
//    static var previews: some View {
//        FlyerCellThisWeek(flyer: asiaverse)
//    }
//}
