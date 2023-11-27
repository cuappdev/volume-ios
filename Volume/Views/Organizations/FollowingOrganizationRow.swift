//
//  FollowingOrganizationRow.swift
//  Volume
//
//  Created by Vin Bui on 11/17/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI

struct FollowingOrganizationRow: View {

    // MARK: - Properties

    let organization: Organization

    // MARK: - UI

    var body: some View {
        VStack(spacing: 5) {
            if let url = organization.profileImageUrl {
                WebImage(url: url)
                    .resizable()
                    .grayBackground()
                    .clipShape(Circle())
                    .frame(width: 75, height: 75)
                    .shadow(color: Color(white: 0, opacity: 0.1), radius: 5)
                    .transition(.fade(duration: 0.5))
                    .padding(.top, 4)
            } else {
                noProfileImageView
            }

            Text(organization.name)
                .font(.newYorkMedium(size: 12))
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(width: 90, height: 135)
    }

    private var noProfileImageView: some View {
        Circle()
            .foregroundColor(.gray)
            .frame(width: 75, height: 75)
            .shadow(color: Color(white: 0, opacity: 0.1), radius: 5)
            .padding(.top, 4)
    }

}

extension FollowingOrganizationRow {

    struct Skeleton: View {
        var body: some View {
            VStack(spacing: 5) {
                SkeletonView()
                    .clipShape(Circle())
                    .shadow(color: Color(white: 0, opacity: 0.1), radius: 5)
                    .frame(width: 75, height: 75)
                    .padding(.top, 4)

                SkeletonView()
                    .frame(width: 65, height: 14)

                Spacer()
            }
            .frame(width: 90, height: 135)
            .shimmer(.smallShimmer())
        }
    }

}
