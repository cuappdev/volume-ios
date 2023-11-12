//
//  Widget+Extension.swift
//  Volume
//
//  Created by Vin Bui on 11/12/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

@available(iOS 17, *)
struct WidgetContentMarginsModifier: ViewModifier {

    @Environment(\.widgetContentMargins) var widgetContentMargins
    var edge: Edge.Set

    func body(content: Content) -> some View {
        content
            .padding(
                EdgeInsets(
                    top: edge.contains(.top) ? widgetContentMargins.top : 0,
                    leading: edge.contains(.leading) ? widgetContentMargins.leading : 0,
                    bottom: edge.contains(.bottom) ? widgetContentMargins.bottom : 0,
                    trailing: edge.contains(.trailing) ? widgetContentMargins.trailing : 0
                )
            )
    }
}

extension View {

    @ViewBuilder
    func addWidgetContentMargins(_ edge: Edge.Set = .all) -> some View {
        if #available(iOS 17, *) {
            modifier(WidgetContentMarginsModifier(edge: edge))
        } else {
            self
        }
    }

}
