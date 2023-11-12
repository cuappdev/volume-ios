//
//  FlyerWidgetView.swift
//  Volume
//
//  Created by Vin Bui on 11/12/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI
import WidgetKit

struct FlyerWidgetView: View {

    // MARK: - Properties

    var entry: FlyerWidgetProvider.Entry

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Spacer()

                Image("v-logo")
                    .resizable()
                    .frame(width: 16, height: 16)
            }

            Spacer()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.flyer.organization.name)
                        .font(.newYorkRegular(size: 12))
                        .lineLimit(1)

                    Text(entry.flyer.title)
                        .font(.helveticaBold(size: 16))
                        .lineLimit(2)
                }

                Spacer()
            }
        }
        .foregroundStyle(Color.white)
        .addWidgetContentMargins()
        .background(background)
    }

    private var background: some View {
        ZStack {
            Color.black.opacity(0.6)

            WebImage(url: entry.flyer.imageUrl)
                .resizable()
                .scaledToFill()

            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .black.opacity(0.1),
                            .black.opacity(0.3),
                            .black.opacity(0.7),
                            .black
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .opacity(0.8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

// MARK: - Uncomment below if needed

//#Preview(as: .systemSmall) {
//    FlyerWidget()
//} timeline: {
//    FlyerEntry(date: .now, article: FlyerWidgetProvider.dummyFlyer!)
//}
