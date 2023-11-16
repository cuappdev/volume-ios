//
//  ArticleWidget.swift
//  Volume
//
//  Created by Vin Bui on 11/11/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI
import WidgetKit

@available(iOS 17.0, *)
struct ArticleWidget: Widget {

    let kind: String = "ArticleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ArticleWidgetProvider()) { entry in
            ArticleWidgetView(entry: entry)
        }
        .configurationDisplayName("Articles")
        .description("View the latest articles from student publications.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }

}
