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
    
    var title: String {
        switch self {
        case .noBookmarks:
            return "Nothing to see here!"
        case .upToDate:
            return "You're up to date!"
        }
    }
    
    var subtitle: String {
        switch self {
        case .noBookmarks:
            return "You have no saved articles"
        case .upToDate:
            return "You've seen all new articles from the publications you're following."
        }
    }
}

struct VolumeMessage: View {
    @State var message: Message
    
    var body: some View {
        VStack(spacing: 10) {
            Image("volume")
                .foregroundColor(Color.volume.orange)
            Text(message.title)
                .font(Font.begumBold(size: 12))
            Text(message.subtitle)
                .font(.custom("Helvetica-Regular", size: 10))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 205, height: 100)
    }
}

struct VolumeMessage_Previews: PreviewProvider {
    static var previews: some View {
        VolumeMessage(message: .upToDate)
    }
}
