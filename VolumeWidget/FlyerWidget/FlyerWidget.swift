//
//  FlyerWidget.swift
//  Volume
//
//  Created by Vin Bui on 11/12/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI
import WidgetKit

@available(iOS 17.0, *)
struct FlyerWidget: Widget {

    let kind: String = "FlyerWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, provider: FlyerWidgetProvider()) { entry in
            FlyerWidgetView(entry: entry)
        }
        .configurationDisplayName("Flyers")
        .description("View the latest flyers from student organizations.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }

}
