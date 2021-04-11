//
//  TabViewContainer.swift
//  Volume
//
//  Created by Sergio Diaz on 4/10/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct TabContainer<Content: View>: View {
    @EnvironmentObject var networkState: NetworkState
    let content: Content

    init(content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            self.content
            .environmentObject(networkState)

            if networkState.networkFailed {
                ConnectionFailedView()
                    .offset(x: 0, y: 48)
            }

        }
    }
}
