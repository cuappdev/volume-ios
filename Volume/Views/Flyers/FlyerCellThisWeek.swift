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
        static let dateFont: Font = .helveticaRegular(size: 12)
        static let frameHeight: CGFloat = 256
        static let frameWidth: CGFloat = 256
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
    }
    
    private var imageFrame: some View {
        ZStack(alignment: .topLeading) {
            // TODO: Remove temporary image holder
            AsyncImage(
                url: URL(string: flyer.imageURL),
                content: { image in
                    image.resizable()
                        .frame(width: Constants.frameWidth, height: Constants.frameHeight)
                },
                placeholder: {
                    SkeletonView()
                        .frame(width: 256, height: 256)
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
    
    @ViewBuilder
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

    @ViewBuilder
    private var shareButton: some View {
        Button {
            Haptics.shared.play(.light)
            // TODO: Bookmark Flyer
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
            
            Spacer()
            
            bookmarkButton
            shareButton
        }
        .padding(.top, Constants.spacing)
        .padding(.bottom, -Constants.spacing)
    }
    
    @ViewBuilder
    private var flyerTitle: some View {
        Text(flyer.title)
            .font(Constants.titleFont)
    }
    
    private var flyerDate: some View {
        HStack {
            Label {
                Text(flyer.date.flyerDateString)
                    .font(Constants.dateFont)
            } icon: {
                Image.volume.calendar
                    .foregroundColor(Color.black)
            }
            
            Text(flyer.date.flyerTimeString)
                .font(Constants.dateFont)
        }
    }
    
    @ViewBuilder
    private var flyerLocation: some View {
        Label {
            Text(flyer.location)
                .font(Constants.locationFont)
        } icon: {
            Image.volume.location
                .foregroundColor(Color.black)
        }
    }
}

extension FlyerCellThisWeek {
    struct Skeleton: View {
        var body: some View {
            SkeletonView()
        }
    }
    
//    struct Skeleton: View {
//        var body: some View {
//            VStack(alignment: .leading) {
//                SkeletonView()
//                    .frame(width: Constants.frameWidth, height: Constants.frameHeight)
//
//                SkeletonView()
//                    .frame(width: 130, height: 15)
//
//                SkeletonView()
//                    .frame(width: 200, height: 20)
//
//                SkeletonView()
//                    .frame(width: 180, height: 15)
//
//                SkeletonView()
//                    .frame(width: 100, height: 15)
//            }
//        }
//    }
    
}

struct FlyerCellThisWeek_Previews: PreviewProvider {
    static var previews: some View {
        FlyerCellThisWeek(flyer: asiaverse)
    }
}
