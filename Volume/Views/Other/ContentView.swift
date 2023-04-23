//
//  ContentView.swift
//  Volume
//
//  Created by Yana Sang on 10/6/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true

    var body: some View {
        if isFirstLaunch {
            OnboardingMainView()
                .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
        } else {
            MainView()
                .transition(.move(edge: .trailing))
        }
    }
}
