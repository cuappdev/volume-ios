//
//  TrendingFlyerCell.swift
//  Volume
//
//  Created by Vin Bui on 4/5/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct TrendingFlyerCell: View {
    
    // MARK: - Properties
    
    let flyer: Flyer
    @StateObject var urlImageModel: URLImageModel
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonSize: CGFloat = 24
        static let categoryCornerRadius: CGFloat = 8
        static let categoryFont: Font = .helveticaRegular(size: 10)
        static let categoryHorizontalPadding: CGFloat = 16
        static let categoryVerticalPadding: CGFloat = 4
        static let dateFont: Font = .helveticaRegular(size: 12)
        static let imageHeight: CGFloat = UIScreen.main.bounds.width - 32
        static let locationFont: Font = .helveticaRegular(size: 12)
        static let organizationNameFont: Font = .newYorkMedium(size: 10)
        static let spacing: CGFloat = 4
        static let titleFont: Font = .newYorkMedium(size: 20)
    }
    
    // MARK: - UI
    
    var body: some View {
        if let url = flyer.flyerUrl {
            cellLinkView(url: url)
        } else {
            cellNoLinkView
        }
    }
    
    private func cellLinkView(url: URL) -> some View {
        Link(destination: url) {
            VStack(alignment: .leading, spacing: Constants.spacing) {
                imageFrame
                organizationName
                flyerTitle
                flyerDate
                flyerLocation
            }
        }
        .buttonStyle(EmptyButtonStyle())
    }
    
    private var cellNoLinkView: some View {
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
            if let flyerImage = urlImageModel.image {
                ZStack(alignment: .center) {
                    Color(uiColor: flyerImage.averageColor ?? .gray)
                    
                    Image(uiImage: urlImageModel.image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: Constants.imageHeight)
                }
            } else {
                SkeletonView()
            }
            
            Text(Organization.contentTypeString(
                    type: flyer.organizations[0].categorySlug)
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
                .clipShape(RoundedRectangle(cornerRadius: Constants.categoryCornerRadius))
                .padding([.top, .leading], 8)
                .frame(alignment: .topLeading)
        }
        .frame(height: Constants.imageHeight)
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
            if flyer.organizations.count > 1 {
                ForEach(flyer.organizations) { organization in
                    Text(organization.name)
                        .font(Constants.organizationNameFont)
                        .lineLimit(1)
                }
            } else {
                Text(flyer.organizations[0].name)
                    .font(Constants.organizationNameFont)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // TODO: Uncomment below once backend finishes
//            bookmarkButton
//            shareButton
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
            
            Text(flyer.startDate.flyerDateString)
                .font(Constants.dateFont)
                .padding(.trailing, Constants.spacing)
                .lineLimit(1)
            
            Text("\(flyer.startDate.flyerTimeString) - \(flyer.endDate.flyerTimeString)")                .font(Constants.dateFont)
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

extension TrendingFlyerCell {
    
    struct Skeleton: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                SkeletonView()
                    .frame(height: Constants.imageHeight)

                SkeletonView()
                    .frame(width: 150, height: 15)

                SkeletonView()
                    .frame(width: 220, height: 20)

                SkeletonView()
                    .frame(width: 200, height: 15)

                SkeletonView()
                    .frame(width: 120, height: 15)
            }
            .shimmer(.largeShimmer())
        }
    }
    
}

// MARK: - Uncomment below if needed

//struct TrendingFlyerCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendingFlyerCell()
//    }
//}
