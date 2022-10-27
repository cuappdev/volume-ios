//
//  VolumeMessage.swift
//  Volume
//
//  Created by Cameron Russell on 11/16/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

enum Message {
    case noBookmarks
    case upToDate
    case noFollowingHome
    case noFollowingPublications

    var title: String {
        switch self {
        case .noBookmarks, .noFollowingHome:
            return "Nothing to see here!"
        case .noFollowingPublications:
            return "No Followed Publications"
        case .upToDate:
            return "You're up to date!"
        }
    }

    var subtitle: String {
        switch self {
        case .noBookmarks:
            return "You have no saved articles"
        case .noFollowingHome:
            return "Follow some student publications that you are interested in"
        case .noFollowingPublications:
            return "Follow some below and we'll show them up here"
        case .upToDate:
            return "You've seen all new articles from the publications you're following."
        }
    }
}

struct VolumeMessage: View {
    @State var message: Message
    @State var largeFont : Bool
    @State var fullWidth : Bool

    var body: some View {
        HStack {
            Spacer()

            VStack(spacing: 10) {
                Image.volume.feed
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
