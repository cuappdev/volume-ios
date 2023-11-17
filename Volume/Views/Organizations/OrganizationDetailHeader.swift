//
//  OrganizationDetailHeader.swift
//  Volume
//
//  Created by Vin Bui on 11/17/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import SwiftUI

struct OrganizationDetailHeader: View {

    // MARK: - Properties

    let navigationSource: NavigationSource
    let organization: Organization

    @State private var followRequestInProgress = false
    @EnvironmentObject private var userData: UserData

    // MARK: - Computed Properties

    /// Returns `true` if this user follows the organization. `false` otherwise.
    private var isFollowed: Bool {
        userData.isOrganizationFollowed(organization)
    }

    /// Returns `true` if the organization's website URL is Instagram. `false` otherwise.
    private var isInstagram: Bool {
        guard let url = organization.websiteUrl else { return false }

        return url.absoluteString.contains("instagram")
    }

    // MARK: - Constants

    private struct Constants {
        static let iconGray: Color = Color(white: 196 / 255)
        static let sidePadding: CGFloat = 16
        static let spacing: CGFloat = 16
    }

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            HStack(alignment: .center) {
                Text(organization.name)
                    .font(.newYorkMedium(size: 18))
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                followButton
            }

            // TODO: Wait till backend creates a metric for num flyers
            Text("\(3) events  •  \(3) upcoming events")
                .font(.helveticaRegular(size: 12))
                .foregroundColor(Color(white: 151 / 255))

            if let bio = organization.bio, !bio.isEmpty {
                Text(bio)
                    .font(.helveticaRegular(size: 14))
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let websiteUrl = organization.websiteUrl {
                externalLink(websiteUrl)
            }
        }
        .padding(.horizontal, Constants.sidePadding)
        .padding(.top, 12)
    }

    private var followButton: some View {
        Button {
            Haptics.shared.play(.light)
            followRequestInProgress = true
            userData.toggleOrganizationFollowed(organization, $followRequestInProgress)

            AppDevAnalytics.log(
                userData.isOrganizationFollowed(organization)
                ? VolumeEvent.followOrganization.toEvent(
                    .organization,
                    value: organization.slug,
                    navigationSource: navigationSource
                )
                : VolumeEvent.unfollowOrganization.toEvent(
                    .organization,
                    value: organization.slug,
                    navigationSource: navigationSource
                )
            )
        } label: {
            Text(isFollowed ? "Following" : "+  Follow")
                .font(.helveticaNeueMedium(size: 12))
                .padding(EdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18))
        }
        .disabled(followRequestInProgress)
        .foregroundColor(isFollowed ? Color.volume.buttonGray: Color.volume.orange)
        .background(
            isFollowed
            ? AnyView(RoundedRectangle(cornerRadius: 10).fill(Color.volume.orange))
            : AnyView(RoundedRectangle(cornerRadius: 10).stroke(Color.volume.orange, lineWidth: 1.5))
        )
    }

    private func externalLink(_ websiteURL: URL) -> some View {
        HStack {
            if isInstagram {
                Image.volume.insta
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(Constants.iconGray)

                MediaText(title: "Instagram", url: websiteURL)
            } else {
                Image.volume.link
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(Constants.iconGray)

                MediaText(title: "Website", url: websiteURL)
            }
        }
    }

}
