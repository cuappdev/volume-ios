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
        let grayColor = UIColor(Color.volume.navigationBarGray)
        UINavigationBar.appearance().backgroundColor = grayColor
        UINavigationBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundColor = grayColor
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.volume.lightGray)
    }

    private func configureFirebase() {
        FirebaseApp.configure()
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
        }
    }
}
