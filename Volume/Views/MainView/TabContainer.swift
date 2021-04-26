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
    let screen: NetworkState.Screen
    let content: Content

    init(networkScreen: NetworkState.Screen, content: () -> Content) {
        self.screen = networkScreen
        self.content = content()
    }

    var body: some View {
        NavigationView {
            ZStack {
                self.content

                if networkState.didNetworkFail(for: screen) {
                    ConnectionFailedView()
                }
            }
        }
    }
}
