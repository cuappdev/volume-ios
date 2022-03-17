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
    case noFollowing

    var title: String {
        switch self {
        case .noBookmarks, .noFollowing:
            return "Nothing to see here!"
        case .upToDate:
            return "You're up to date!"
        }
    }

    var subtitle: String {
        switch self {
        case .noBookmarks:
            return "You have no saved articles"
        case .noFollowing:
            return "Follow some student publications that you are interested in"
        case .upToDate:
            return "You've seen all new articles from the publications you're following."
        }
    }
}

struct VolumeMessage: View {
    @State var message: Message
    @State var largeFont : Bool

    var body: some View {
        VStack(spacing: 10) {
            Image.volume.feed
                .foregroundColor(.volume.orange)
            Text(message.title)
                .font(.newYorkMedium(size: largeFont ? 24 : 18))
            Text(message.subtitle)
                .font(.helveticaRegular(size: 12))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: largeFont ? nil : 205, height: 100)
    }
}

struct VolumeMessage_Previews: PreviewProvider {
    static var previews: some View {
        VolumeMessage(message: .upToDate, largeFont: false)
    }
}
