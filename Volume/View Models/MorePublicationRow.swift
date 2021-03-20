//
//  PublicationRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import SDWebImageSwiftUI
import SwiftUI

/// `MorePublicationRow` displays the basis information about a publications the user is not currently following
struct MorePublicationRow: View {
    @EnvironmentObject private var userData: UserData

    let entryPoint: EntryPoint
    let publication: Publication

    var body: some View {
        HStack(alignment: .top) {
            if let imageUrl = publication.profileImageUrl {
                WebImage(url: imageUrl)
                    .grayBackground()
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 60, height: 60)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(publication.name)
                    .font(.begumMedium(size: 18))
                    .foregroundColor(.black)
                Text(publication.bio)
                    .font(.helveticaRegular(size: 12))
                    .foregroundColor(Color(white: 151 / 255))
                    .truncationMode(.tail)
                    .lineSpacing(4)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                if let recent = publication.recent {
                    HStack {
                        Text("|")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(white: 225 / 255))
                        Text("\"\(recent)\"")
                            .lineLimit(1)
                            .font(.helveticaRegular(size: 12))
                            .foregroundColor(.black)
                    }
                    .padding(.top, 2)
                }
            }

            Spacer()

            Button(action: {
                withAnimation {
                    userData.togglePublicationFollowed(publication)
                    let params = Parameters.params(for: .publication, id: publication.id, at: entryPoint)
                    AppDevAnalytics.log(
                        userData.isPublicationFollowed(publication) ?
                            FollowPublication(parameters: params) :
                            UnfollowPublication(parameters: params)
                    )
                }
            }) {
                Image(userData.isPublicationFollowed(publication) ? "followed" : "follow")
            }
        }.padding([.leading, .trailing])
    }
}

extension MorePublicationRow {
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
            }.padding([.leading, .trailing])
        }
    }
}

//struct MorePublicationRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MorePublicationRow(
//            publication: Publication(
//                description: "CU",
//                name: "CUNooz",
//                id: "sdfsdf",
//                imageURL: nil,
//                recent: "Sandpaper Tastes Like What?!"
//            )
//        ) { publication in
//
//        }
//    }
//}
