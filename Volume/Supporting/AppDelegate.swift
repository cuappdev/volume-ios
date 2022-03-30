//
//  AppDelegate.swift
//  Volume
//
//  Created by Hanzheng Li on 9/29/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import FirebaseMessaging
import SDWebImageSVGCoder
import SwiftUI
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    private let notificationIntervalKey = "notificationIntervalKey"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Add SVG Support
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)

        if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            // App was launched by tapping notification
            Notifications.shared.handlePushNotification(userInfo: userInfo)
            logNotificationStartTime()
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("UIApplicationDelegate didRegisterForRemoteNotifications with deviceToken: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error: UIApplicationDelegate didFailToRegisterForRemoteNotificationsWithError: \(error.localizedDescription)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        logTimeActiveAfterNotification()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        logTimeActiveAfterNotification()
    }
    
    // MARK: Analytics
    
    private func logNotificationStartTime() {
        AppDevAnalytics.log(VolumeEvent.clickNotification.toEvent(.notification, value: "", navigationSource: .pushNotification))
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: notificationIntervalKey)
    }
    
    private func logTimeActiveAfterNotification() {
        guard let openDateDouble = UserDefaults.standard.object(forKey: notificationIntervalKey) as? Double else {
            return
        }
        let openDate = Date(timeIntervalSince1970: openDateDouble)
        let elapsedTime = Calendar.current.dateComponents([.second], from: openDate, to: Date())
        if let duration = elapsedTime.second {
            AppDevAnalytics.log(VolumeEvent.notificationIntervalClose.toEvent(.notificationInterval, value: String(duration), navigationSource: .unspecified))
        }
    }
}
