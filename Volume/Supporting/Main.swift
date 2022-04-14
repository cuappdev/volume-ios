//
//  Main.swift
//  Volume
//
//  Created by Sergio Diaz on 4/26/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import AppDevAnnouncements
import Firebase
import SwiftUI

@main
struct Main: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    init() {
        configureFirebase()
        configureNotifications()
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().tintColor = UIColor(Color.black)
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().clipsToBounds = true
    }

    private func configureFirebase() {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        AnnouncementNetworking.setupConfig(
            scheme: Secrets.announcementsScheme,
            host: Secrets.announcementsHost,
            commonPath: Secrets.announcementsCommonPath,
            announcementPath: Secrets.announcementsPath
        )
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
        }
    }
}
