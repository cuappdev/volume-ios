//
//  OrganizationDetail.swift
//  Volume
//
//  Created by Vin Bui on 11/17/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI

struct OrganizationDetail: View {

    // MARK: - Properties

    let navigationSource: NavigationSource
    let organization: Organization

    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    // MARK: - Constants

    private struct Constants {
        static let backButtonLeadingPadding: CGFloat = 20
        static let backButtonTopPadding: CGFloat = 55
        static let coverImageHeight: CGFloat = 140
        static let coverImageOverlayHeight: CGFloat = 156
        static let dividerWidth: CGFloat = 100
        static let dragGestureMaxX: CGFloat = 100
        static let dragGestureMinX: CGFloat = 20
        static let horizontalPadding: CGFloat = 18
        static let profileImageDimension: CGFloat = 60
        static let profileImageStrokeWidth: CGFloat = 3
        static let shadowRadius: CGFloat = 4
    }

    // MARK: - UI

    var body: some View {
        GeometryReader { _ in
            ScrollView {
                coverImageHeader
                contentSection
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .background(Color.white)
            .gesture(
                DragGesture().updating($dragOffset) { value, _, _ in
                    if value.startLocation.x < Constants.dragGestureMinX,
                       value.translation.width > Constants.dragGestureMaxX {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }

    private var coverImageHeader: some View {
        VStack(alignment: .center) {
            ZStack {
                coverImage
                coverImageOverlay
            }
            .frame(height: Constants.coverImageOverlayHeight)

            orgDescription
            divider
        }
    }

    private var coverImage: some View {
        GeometryReader { geometry in
            let scrollOffset = geometry.frame(in: .global).minY
            let headerOffset = scrollOffset > 0 ? -scrollOffset : 0
            let headerHeight = geometry.size.height + max(scrollOffset, 0)

            WebImage(url: organization.backgroundImageUrl)
                .resizable()
                .grayBackground()
                .scaledToFill()
                .frame(width: geometry.size.width, height: headerHeight)
                .clipped()
                .offset(y: headerOffset)
        }
        .frame(height: Constants.coverImageHeight)
    }

    private var coverImageOverlay: some View {
        HStack {
            VStack(alignment: .leading) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image.volume.backArrow
                        .foregroundColor(Color.white)
                        .padding(.top, Constants.backButtonTopPadding)
                        .padding(.leading, Constants.backButtonLeadingPadding)
                        .shadow(color: Color.black, radius: Constants.shadowRadius)
                }

                Spacer()

                WebImage(url: organization.profileImageUrl)
                    .grayBackground()
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: Constants.profileImageDimension, height: Constants.profileImageDimension)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: Constants.profileImageStrokeWidth)
                    )
                    .shadow(color: Color.volume.shadowBlack, radius: Constants.shadowRadius)
                    .padding(.leading, Constants.horizontalPadding)
            }

            Spacer()
        }
    }

    private var orgDescription: some View {
        OrganizationDetailHeader(
            navigationSource: navigationSource,
            organization: organization
        )
        .padding(.bottom)
    }

    private var contentSection: some View {
        OrganizationContentView(
            navigationSource: navigationSource,
            organization: organization
        )
        .padding(.top, 16)
    }

    // MARK: - Supporting Views

    private var divider: some View {
        Divider()
            .background(Color.volume.veryLightGray)
            .frame(width: Constants.dividerWidth)
    }

}
