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
    case noBookmarkedMagazines
    case noFollowingHome
    case noFollowingPublications
    case noSearchResults
    case upToDate

    var title: String {
        switch self {
        case .noBookmarkedArticles, .noBookmarkedMagazines, .noFollowingHome, .noSearchResults:
            return "Nothing to see here!"
        case .noFollowingPublications:
            return "No Followed Publications"
        case .upToDate:
            return "You're up to date!"
        }
    }

    var subtitle: String {
        switch self {
        case .noBookmarkedArticles:
            return "You have no saved articles"
        case .noBookmarkedMagazines:
            return "You have no saved magazines"
        case .noFollowingHome:
            return "Follow some student publications that you are interested in"
        case .noFollowingPublications:
            return "Follow some below and we'll show them up here"
        case .upToDate:
            return "You've seen all new articles from the publications you're following."
        case .noSearchResults:
            return "We could not find any results."
        }
    }
}

struct VolumeMessage: View {
    @State var image: Image = Image.volume.feed
    @State var message: Message
    @State var largeFont : Bool
    @State var fullWidth : Bool

    var body: some View {
        HStack {
            Spacer()

            VStack(spacing: 10) {
                image
                    .foregroundColor(.volume.orange)
                Text(message.title)
                    .font(.newYorkMedium(size: largeFont ? 24 : 18))
                Text(message.subtitle)
                    .font(.helveticaRegular(size: 12))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
            }
            .frame(width: fullWidth ? nil : 205, height: 100)

            Spacer()
        }
    }
}
