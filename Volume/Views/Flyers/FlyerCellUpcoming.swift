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
    let navigationSource: NavigationSource
    
    @State private var bookmarkRequestInProgress: Bool = false
    @StateObject var urlImageModel: URLImageModel
    @EnvironmentObject private var userData: UserData
    @ObservedObject var viewModel: FlyersView.ViewModel
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonSize: CGSize = CGSize(width: 18, height: 18)
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
                }
            }
            .frame(width: Constants.cellWidth, height: Constants.cellHeight)
        }
        .buttonStyle(EmptyButtonStyle())
        .simultaneousGesture(
            TapGesture().onEnded {
                Task {
                    await viewModel.readFlyer(flyer)
                }
            }
        )
    }
    
    private var cellNoLinkView: some View {
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
        ZStack(alignment: .center) {
            if let flyerImage = urlImageModel.image {
                Color(uiColor: flyerImage.averageColor ?? .gray)
                
                Image(uiImage: urlImageModel.image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                SkeletonView()
                    .shimmer(.smallShimmer())
            }
        }
        .frame(width: Constants.imageWidth, height: Constants.imageHeight)
    }
    
    private var organizationName: some View {
        HStack(alignment: .center) {
            Text(flyer.organization.name)
                .font(Constants.organizationNameFont)
                .lineLimit(2)
            
            Spacer()
            
            FlyersBookmark(buttonSize: Constants.buttonSize, flyer: flyer, isPast: false, navigationSource: navigationSource)
            FlyersShare(buttonSize: Constants.buttonSize, flyer: flyer, isPast: false, navigationSource: navigationSource)
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
            .shimmer(.smallShimmer())
        }
    }
    
}

// MARK: - Uncomment below if needed

//struct FlyerCellUpcoming_Previews: PreviewProvider {
//    static var previews: some View {
//        FlyerCellUpcoming(flyer: springFormal)
//    }
//}
