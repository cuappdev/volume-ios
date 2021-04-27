//
//  TabViewContainer.swift
//  Volume
//
//  Created by Sergio Diaz on 4/10/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct TabContainer<Content: View>: View {
    @EnvironmentObject private var networkState: NetworkState
    private let screen: NetworkState.Screen
    private let content: Content

    init(screen: NetworkState.Screen, content: () -> Content) {
        self.screen = screen
        self.content = content()
    }

    var body: some View {
        NavigationView {
            ZStack {
                content

                if networkState.networkDidFail(on: screen) {
                    ConnectionFailedView()
                }
            }
        }
    }
}
