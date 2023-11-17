//
//  MoreOrganizationRow.swift
//  Volume
//
//  Created by Vin Bui on 11/17/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import SDWebImageSwiftUI
import SwiftUI

struct MoreOrganizationRow: View {

    // MARK: - Properties

    @EnvironmentObject private var userData: UserData
    @State private var followRequestInProgress = false

    let organization: Organization
    let navigationSource: NavigationSource

    // MARK: - UI

    var body: some View {
        HStack(alignment: .top) {
            orgImageView
            orgDetailView

            Spacer()

            followButton
        }
    }

    @ViewBuilder
    private var orgImageView: some View {
        if let imageUrl = organization.profileImageUrl {
            WebImage(url: imageUrl)
                .grayBackground()
                .resizable()
                .clipShape(Circle())
                .frame(width: 60, height: 60)
        } else {
            noProfileImageView
        }
    }

    private var orgDetailView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(organization.name)
                .font(.newYorkMedium(size: 18))
                .foregroundColor(.black)

            Text(organization.bio ?? "")
                .font(.helveticaRegular(size: 12))
                .foregroundColor(Color(white: 151 / 255))
                .truncationMode(.tail)
                .lineSpacing(4)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .multilineTextAlignment(.leading)
    }

    private var followButton: some View {
        Button {
            Haptics.shared.play(.light)

            withAnimation {
                followRequestInProgress = true
                userData.toggleOrganizationFollowed(organization, $followRequestInProgress)

                AppDevAnalytics.log(
                    userData.isOrganizationFollowed(organization)
                    ? VolumeEvent.followOrganization.toEvent(
                        .organization,
                        value: organization.slug,
                        navigationSource: navigationSource
                    ) : VolumeEvent.unfollowOrganization.toEvent(
                        .organization,
                        value: organization.slug,
                        navigationSource: navigationSource
                    )
                )
            }
        } label: {
            Image(userData.isOrganizationFollowed(organization) ? "followed" : "follow")
        }
        .disabled(followRequestInProgress)
    }

    private var noProfileImageView: some View {
        Circle()
            .fill(Color.gray)
            .frame(width: 60, height: 60)
    }

}

extension MoreOrganizationRow {

    struct Skeleton: View {
        var body: some View {
            HStack(alignment: .top) {
                SkeletonView()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)

                VStack(alignment: .leading, spacing: 0) {
                    SkeletonView()
                        .frame(width: 80, height: 23)
                        .padding(.bottom, 5)

                    SkeletonView()
                        .frame(height: 15)
                        .padding(.bottom, 4)
                    SkeletonView()
                        .frame(height: 15)
                        .padding(.bottom, 5)

                    HStack {
                        Text("|")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(white: 225 / 255))
                        SkeletonView()
                            .frame(height: 14)
                    }
                    .padding(.top, 2)
                }

                Spacer()

                SkeletonView()
                    .frame(width: 24, height: 24)
                    .cornerRadius(8)
            }
            .padding([.leading, .trailing])
            .shimmer(.smallShimmer())
        }
    }

}
