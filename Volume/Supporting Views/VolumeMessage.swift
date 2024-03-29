//
//  VolumeMessage.swift
//  Volume
//
//  Created by Cameron Russell on 11/16/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

enum Message {

    case noBookmarkedArticles
    case noBookmarkedFlyers
    case noBookmarkedMagazines
    case noFlyersOrgAdmin
    case noFlyersOrgDetail
    case noFlyersPast
    case noFlyersUpcoming
    case noFollowingHome
    case noFollowingOrganizations
    case noFollowingPublications
    case noSearchResults
    case upToDateArticles
    case upToDateFlyers

    var title: String {
        switch self {
        case .noBookmarkedArticles, .noBookmarkedMagazines, .noFollowingHome, .noSearchResults, .noBookmarkedFlyers:
            return "Nothing to see here!"
        case .noFollowingOrganizations:
            return "No followed organizations."
        case .noFollowingPublications:
            return "No followed publications."
        case .upToDateArticles:
            return "You're up to date!"
        case .upToDateFlyers:
            return "Are you an organization?"
        case .noFlyersPast:
            return "No past flyers."
        case .noFlyersUpcoming:
            return "No upcoming flyers for this category."
        case .noFlyersOrgAdmin:
            return "No flyers to display."
        case .noFlyersOrgDetail:
            return "There's nothing here."
        }
    }

    var subtitle: String {
        switch self {
        case .noBookmarkedFlyers:
            return "You have no saved flyers for this section."
        case .noBookmarkedArticles:
            return "You have no saved articles."
        case .noBookmarkedMagazines:
            return "You have no saved magazines."
        case .noFollowingHome:
            return "Follow some student publications that you are interested in."
        case .noFollowingOrganizations, .noFollowingPublications:
            return "Follow some below and we'll display them here."
        case .upToDateArticles:
            return "You've seen all new articles from the publications you're following."
        case .noSearchResults:
            return "We could not find any results."
        case .upToDateFlyers, .noFlyersPast, .noFlyersUpcoming:
            return "If you want to see your organization’s events on Volume, email us at volumeappdev@gmail.com."
        case .noFlyersOrgAdmin:
            return "Upload a flyer above to see them displayed here."
        case .noFlyersOrgDetail:
            return "It seems like this organization hasn’t published any flyers yet."
        }
    }

}

struct VolumeMessage: View {

    @State var image: Image = Image.volume.feed
    @State var message: Message
    @State var largeFont: Bool
    @State var fullWidth: Bool

    var body: some View {
        HStack {
            Spacer()

            VStack(spacing: 10) {
                image
                    .foregroundColor(.volume.orange)

                Text(message.title)
                    .font(.newYorkMedium(size: largeFont ? 24 : 18))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text(message.subtitle)
                    .font(.helveticaRegular(size: 12))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: fullWidth ? nil : 205, height: 100)

            Spacer()
        }
    }

}
