//
//  FlyerCellPast.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FlyerCellPast: View {
    
    // MARK: - Properties
    
    let flyer: Flyer
    
    @State private var bookmarkRequestInProgress: Bool = false
    @StateObject var urlImageModel: URLImageModel
    @EnvironmentObject private var userData: UserData
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonSize: CGFloat = 18
        static let categoryCornerRadius: CGFloat = 8
        static let categoryFont: Font = .helveticaRegular(size: 10)
        static let categoryHorizontalPadding: CGFloat = 16
        static let categoryVerticalPadding: CGFloat = 4
        static let cellSpacing: CGFloat = 16
        static let dateFont: Font = .helveticaRegular(size: 12)
        static let horizontalSpacing: CGFloat = 8
        static let imageHeight: CGFloat = 123
        static let imageWidth: CGFloat = 123
        static let locationFont: Font = .helveticaRegular(size: 12)
        static let organizationNameFont: Font = .newYorkMedium(size: 10)
        static let titleFont: Font = .newYorkMedium(size: 16)
        static let verticalSpacing: CGFloat = 8
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
            HStack(alignment: .top, spacing: Constants.horizontalSpacing) {
                imageFrame
                
                VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
                    organizationName
                    flyerTitle
                    flyerDate
                    flyerLocation
                    categoryType
                }
            }
            .padding(.bottom, Constants.cellSpacing)
        }
        .buttonStyle(EmptyButtonStyle())
    }
    
    private var cellNoLinkView: some View {
        HStack(alignment: .top, spacing: Constants.horizontalSpacing) {
            imageFrame
            
            VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
                organizationName
                flyerTitle
                flyerDate
                flyerLocation
                categoryType
            }
        }
        .padding(.bottom, Constants.cellSpacing)
    }
    
    private var imageFrame: some View {
        // TODO: Remove temporary image holder
        ZStack(alignment: .center) {
            if let flyerImage = urlImageModel.image {
                Color(uiColor: flyerImage.averageColor ?? .gray)
                
                Image(uiImage: urlImageModel.image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                SkeletonView()
            }
        }
        .frame(width: Constants.imageWidth, height: Constants.imageHeight)
    }
    
    @ViewBuilder
    private var bookmarkButton: some View {
        if userData.isFlyerSaved(flyer) {
            Image.volume.bookmarkFilled
                .resizable()
                .scaledToFit()
                .foregroundColor(.volume.orange)
                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                .onTapGesture {
                    withAnimation {
                        Haptics.shared.play(.light)
                        toggleSaved(for: flyer)
                    }
                }
        } else {
            Image.volume.bookmark
                .resizable()
                .scaledToFit()
                .foregroundColor(.volume.orange)
                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                .onTapGesture {
                    withAnimation {
                        Haptics.shared.play(.light)
                        toggleSaved(for: flyer)
                    }
                }
        }
    }

    private var shareButton: some View {
        Image.volume.share
            .resizable()
            .foregroundColor(.black)
            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
            .onTapGesture {
                Haptics.shared.play(.light)
                FlyersView.ViewModel.displayShareScreen(for: flyer)
            }
    }
    
    private var organizationName: some View {
        HStack(alignment: .top) {
            if flyer.organizations.count > 1 {
                ForEach(flyer.organizations) { organization in
                    Text(organization.name)
                        .font(Constants.organizationNameFont)
                        .lineLimit(2)
                }
            } else {
                if let name = flyer.organizations.first?.name {
                    Text(name)
                        .font(Constants.organizationNameFont)
                        .lineLimit(2)
                }
            }
            
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
            
            Text(flyer.startDate.flyerDateString)
                .font(Constants.dateFont)
                .padding(.trailing, Constants.horizontalSpacing)
                .lineLimit(1)
            
            Text("\(flyer.startDate.flyerTimeString) - \(flyer.endDate.flyerTimeString)")
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
    
    @ViewBuilder
    private var categoryType: some View {
        if let categorySlug = flyer.organizations.first?.categorySlug {
            Text(Organization.contentTypeString(
                type: categorySlug)
            )
            .padding(.init(
                top: Constants.categoryVerticalPadding,
                leading: Constants.categoryHorizontalPadding,
                bottom: Constants.categoryVerticalPadding,
                trailing: Constants.categoryHorizontalPadding
            ))
            .font(Constants.categoryFont)
            .foregroundColor(Color.volume.orange)
            .background(Color.white)
            .cornerRadius(Constants.categoryCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.categoryCornerRadius)
                    .stroke(Color.volume.orange, lineWidth: 1)
            )
        }
    }
    
    // MARK: - Bookmarking Logic
    
    private func toggleSaved(for flyer: Flyer) {
        bookmarkRequestInProgress = true
        userData.toggleFlyerSaved(flyer, $bookmarkRequestInProgress)
    }
    
}

extension FlyerCellPast {
    
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
                    
                    SkeletonView()
                        .frame(width: 60, height: 15)
                }
            }
            .shimmer(.mediumShimmer())
        }
    }
    
}

// MARK: - Uncomment below if needed

//struct FlyerCellPast_Previews: PreviewProvider {
//    static var previews: some View {
//        FlyerCellPast(flyer: asiaverse)
//    }
//}
