//
//  Main.swift
//  Volume
//
//  Created by Sergio Diaz on 4/26/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import Firebase
import SwiftUI

@main
struct Main: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    init() {
        configureFirebase()
        configureNotifications()
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().tintColor = .black
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().clipsToBounds = true
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    private func configureFirebase() {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
    }

    private func configureNotifications() {
        Notifications.shared.requestAuthorization()
        Notifications.shared.registerForRemoteNotifications()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserData.shared)
                .environmentObject(NetworkState())
                .environmentObject(Notifications.shared)
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .background {
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                }
        }
    }
}
