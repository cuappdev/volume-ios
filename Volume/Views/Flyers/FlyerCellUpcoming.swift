//
//  FlyerCellUpcoming.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FlyerCellUpcoming: View {
    
    // MARK: - Properties
    
    let flyer: Flyer
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonSize: CGFloat = 18
        static let cellWidth: CGFloat = 325
        static let cellHeight: CGFloat = 92
        static let dateFont: Font = .helveticaRegular(size: 12)
        static let imageHeight: CGFloat = 92
        static let imageWidth: CGFloat = 92
        static let horizontalSpacing: CGFloat = 8
        static let locationFont: Font = .helveticaRegular(size: 12)
        static let organizationNameFont: Font = .newYorkMedium(size: 10)
        static let titleFont: Font = .newYorkMedium(size: 16)
        static let verticalSpacing: CGFloat = 4
    }
    
    // MARK: - UI
    
    var body: some View {
        HStack(alignment: .top, spacing: Constants.horizontalSpacing) {
            imageFrame
            
            VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
                organizationName
                flyerTitle
                flyerDate
                flyerLocation
            }
        }
        .frame(width: Constants.cellWidth, height: Constants.cellHeight)
    }
    
    private var imageFrame: some View {
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
        HStack(alignment: .center) {
            Text(flyer.organization.name)
                .font(Constants.organizationNameFont)
                .lineLimit(2)
            
            Spacer()
            
            bookmarkButton
            shareButton
        }
        .padding(.bottom, -Constants.verticalSpacing)
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
                .padding(.trailing, Constants.horizontalSpacing)
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

extension FlyerCellUpcoming {
    
    struct Skeleton: View {
        var body: some View {
            HStack {
                SkeletonView()
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                
                VStack(alignment: .leading) {
                    SkeletonView()
                        .frame(width: 130, height: 15)
                    
                    SkeletonView()
                        .frame(width: 200, height: 20)
                    
                    SkeletonView()
                        .frame(width: 180, height: 15)
                    
                    SkeletonView()
                        .frame(width: 100, height: 15)
                }
            }
            .frame(width: Constants.cellWidth, height: Constants.cellHeight)
        }
    }
    
}

// MARK: - Uncomment below if needed

//struct FlyerCellUpcoming_Previews: PreviewProvider {
//    static var previews: some View {
//        FlyerCellUpcoming(flyer: springFormal)
//    }
//}
