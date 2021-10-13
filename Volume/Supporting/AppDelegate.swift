//
//  AppDelegate.swift
//  Volume
//
//  Created by Hanzheng Li on 9/29/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("UIApplicationDelegate didRegisterForRemoteNotifications with deviceToken: \(deviceTokenString)")
        // send device token to backend
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("UIApplicationDelegate didRegisterForRemoteNotifications with error: \(error.localizedDescription)")
    }
}
