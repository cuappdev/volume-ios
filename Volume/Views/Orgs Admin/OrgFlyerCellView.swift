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

    @State private var showConfirmation: Bool = false
    @ObservedObject var urlImageModel: URLImageModel
    @EnvironmentObject private var userData: UserData
    @ObservedObject var viewModel: OrgsAdminView.ViewModel

    // MARK: - Constants

    private struct Constants {
        static let circleSize: CGFloat = 4
        static let horizontalSpacing: CGFloat = 8
        static let imageSize: CGFloat = 80
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
        ZStack(alignment: .topTrailing) {
            Link(destination: url) {
                HStack(alignment: .top, spacing: Constants.horizontalSpacing) {
                    imageFrame

                    VStack(alignment: .leading, spacing: 8) {
                        organizationName
                        flyerTitle
                        flyerDate
                        flyerLocation
                    }
                }
            }
            .buttonStyle(EmptyButtonStyle())

            tripleDotsButton
        }
    }

    private var cellNoLinkView: some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .top, spacing: Constants.horizontalSpacing) {
                imageFrame

                VStack(alignment: .leading, spacing: 8) {
                    organizationName
                    flyerTitle
                    flyerDate
                    flyerLocation
                }
            }

            tripleDotsButton
        }
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
        .frame(width: Constants.imageSize, height: Constants.imageSize)
    }

    private var organizationName: some View {
        HStack(alignment: .top) {
            Text(flyer.organization.name)
                .font(.newYorkMedium(size: 10))
                .lineLimit(2)

            Spacer()
        }
        .padding(.bottom, -Constants.verticalSpacing)
    }

    private var tripleDotsButton: some View {
        Menu {
            NavigationLink {
                FlyerUploadView(flyer: flyer, isEditing: true, organization: flyer.organization)
            } label: {
                Text("Edit Flyer")
            }

            Button("Delete Flyer", role: .destructive) {
                showConfirmation = true
            }
        } label: {
            HStack(alignment: .center, spacing: 2) {
                ForEach(0..<3) { _ in
                    Circle()
                        .fill()
                        .foregroundColor(Color.gray)
                        .frame(width: Constants.circleSize, height: Constants.circleSize)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 0))
        }
        .confirmationDialog(
            "Removing a flyer will delete it from Volume’s feed.",
            isPresented: $showConfirmation,
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive) {
                Task {
                    await viewModel.deleteFlyer(flyerID: flyer.id, organization: flyer.organization)
                }
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

extension OrgFlyerCellView {

    struct Skeleton: View {
        var body: some View {
            HStack {
                SkeletonView()
                    .frame(width: Constants.imageSize, height: Constants.imageSize)

                VStack(alignment: .leading) {
                    SkeletonView()
                        .frame(width: 130, height: 15)

                    SkeletonView()
                        .frame(width: 200, height: 15)

                    SkeletonView()
                        .frame(width: 180, height: 15)

                    SkeletonView()
                        .frame(width: 100, height: 15)
                }
            }
            .shimmer(.mediumShimmer())
        }
    }

}

// MARK: - Uncomment below if needed

//#Preview {
//    OrgFlyerCellView()
//}
