//
//  ArticleWidgetView.swift
//  Volume
//
//  Created by Vin Bui on 11/11/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI
import WidgetKit

@available(iOS 17.0, *)
struct ArticleWidgetView: View {

    // MARK: - Properties

    var entry: ArticleWidgetProvider.Entry

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
                    Text(entry.article.publication.name)
                        .font(.newYorkRegular(size: 12))
                        .lineLimit(1)

                    Text(entry.article.title)
                        .font(.helveticaBold(size: 16))
                        .lineLimit(2)
                }

                Spacer()
            }
        }
        .foregroundStyle(Color.white)
        .addWidgetContentMargins()
        .containerBackground(for: .widget, alignment: .center) {
            background
        }
        .background(background)
        .widgetURL(URL(string: "\(Secrets.openArticleUrl)\(entry.article.id)"))
    }

    private var background: some View {
        ZStack {
            Color.black.opacity(0.6)

            WidgetImage(url: entry.article.imageUrl)

            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .black.opacity(0.2),
                            .black.opacity(0.5),
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
//    ArticleWidget()
//} timeline: {
//    ArticleEntry(date: .now, article: ArticleWidgetProvider.dummyArticle!)
//}
