//
//  OrgFlyerCellView.swift
//  Volume
//
//  Created by Cindy Liang on 11/4/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct OrgFlyerCellView: View {
    
    // MARK: - Properties

    let flyer: Flyer
    let navigationSource: NavigationSource

    @StateObject var urlImageModel: URLImageModel
    @EnvironmentObject private var userData: UserData

    // MARK: - Constants

    private struct Constants {
        static let horizontalSpacing: CGFloat = 8
        static let verticalSpacing: CGFloat = 8
        static let circleSize: CGFloat = 3
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Constants.horizontalSpacing) {
            imageFrame

            VStack(alignment: .leading, spacing: 8) {
                organizationName
                flyerTitle
                flyerDate
                flyerLocation
            }
        }
        .padding(.bottom, 16)
    }
    
    private var imageFrame: some View {
        ZStack(alignment: .center) {
            if let flyerImage = urlImageModel.image {
                Color(uiColor: flyerImage.averageColor ?? .gray)

                Image(uiImage: urlImageModel.image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                SkeletonView()
                    .shimmer(.mediumShimmer())
            }
        }
        .frame(width: 80, height: 80)
    }
    
    private var organizationName: some View {
        HStack(alignment: .top) {
            Text(flyer.organization.name)
                .font(.newYorkMedium(size: 10))
                .lineLimit(2)

            Spacer()
            
            tripleDotsButton
        }
        .padding(.bottom, -Constants.verticalSpacing)
    }
    
    private var tripleDotsButton: some View {
        HStack(alignment: .center, spacing: 2) {
            ForEach(0..<3) { _ in
                Circle()
                    .fill()
                    .foregroundColor(Color.gray)
                    .frame(width: Constants.circleSize, height: Constants.circleSize)
            }
        }
    }
    
    private var flyerTitle: some View {
        Text(flyer.title)
            .font(.newYorkMedium(size: 16))
            .lineLimit(1)
    }
    
    private var flyerDate: some View {
        HStack {
            Image.volume.calendar
                .foregroundColor(Color.black)

            Text(flyer.startDate.flyerDateString)
                .font(.helveticaRegular(size: 12))
                .padding(.trailing, Constants.horizontalSpacing)
                .lineLimit(1)

            Text("\(flyer.startDate.flyerTimeString) - \(flyer.endDate.flyerTimeString)")
                .font(.helveticaRegular(size: 12))
                .lineLimit(1)
        }
    }

    private var flyerLocation: some View {
        HStack {
            Image.volume.location
                .foregroundColor(Color.black)

            Text(flyer.location)
                .font(.helveticaRegular(size: 12))
                .lineLimit(1)
        }
    }
    
}

// MARK: - Uncomment below if needed

//#Preview {
//    OrgFlyerCellView()
//}
