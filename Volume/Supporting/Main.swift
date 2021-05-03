//
//  Main.swift
//  Volume
//
//  Created by Sergio Diaz on 4/26/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnnouncements
import Firebase
import SwiftUI

@main
struct Main: App {
    init() {
        configureFirebase()

        let grayColor = UIColor(Color.volume.navigationBarGray)
        UINavigationBar.appearance().backgroundColor = grayColor
        UINavigationBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundColor = grayColor
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.volume.lightGray)
    }

    func configureFirebase() {
        FirebaseApp.configure()
        AnnouncementNetworking.setupConfig(
            scheme: Secrets.announcementsScheme,
            host: Secrets.announcementsHost,
            commonPath: Secrets.announcementsCommonPath,
            announcementPath: Secrets.announcementsPath
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserData())
                .environmentObject(NetworkState())
        }
    }
}
