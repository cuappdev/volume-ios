//
//  AppDelegate.swift
//  Volume
//
//  Created by Hanzheng Li on 9/29/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    private let notificationIntervalKey = "notificationIntervalKey"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if let _ = launchOptions?[.remoteNotification] {
            // app not running in background, user taps notification
            AppDevAnalytics.log(VolumeEvent.clickNotification.toEvent(.notification, value: "", navigationSource: .pushNotification))
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: notificationIntervalKey)
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("UIApplicationDelegate didRegisterForRemoteNotifications with deviceToken: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("UIApplicationDelegate didRegisterForRemoteNotifications with error: \(error.localizedDescription)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // app running in background, user taps notification
        AppDevAnalytics.log(VolumeEvent.clickNotification.toEvent(.notification, value: "", navigationSource: .pushNotification))
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: notificationIntervalKey)
        completionHandler()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        logTimeActive()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        logTimeActive()
    }
    
    private func logTimeActive() {
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
