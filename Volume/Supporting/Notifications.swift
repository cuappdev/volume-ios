//
//  Notifications.swift
//  Volume
//
//  Created by Hanzheng Li on 11/17/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import Foundation
import UserNotifications

protocol NotificationsArticleDelegate {
    func openArticle(id: String)
}

class Notifications: NSObject {
    static let shared = Notifications()
    
    let center = UNUserNotificationCenter.current()
    var articleDelegate: NotificationsArticleDelegate?
    
    private override init() {
        super.init()
        center.delegate = self
    }
    
    func requestAuthorization() {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                self.center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if granted {
                        let event = VolumeEvent.enableNotification.toEvent(.notification, value: "", navigationSource: .unspecified)
                        AppDevAnalytics.log(event)
                    } else if let error = error {
                        print("Error requesting push notification permissions: \(error)")
                    }
                }
            }
        }
    }
    
    func registerForRemoteNotifications() {
        if !UIApplication.shared.isRegisteredForRemoteNotifications {
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func handlePushNotification(userInfo: [AnyHashable: Any]) {
        print("handling push notification with userInfo: \(userInfo)")
        if let data = userInfo["data"] as? [String: Any],
            let notificationType = data["notificationType"] as? String {
            switch notificationType {
            case NotificationType.newArticle.rawValue:
                guard let articleID = data["articleID"] as? String else {
                    print("Error: missing articleID in new article notification payload")
                    return
                }
                print("parsed articleID: \(articleID)")
                articleDelegate?.openArticle(id: articleID)
            default:
                // later: add case for weekly debrief
                print("Error: unknown notificationType: \(notificationType)")
                break
            }
            return
        }
        print("Error: data or notificationType not found in push notification payload")
    }
}

extension Notifications: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // App is running in the background, user taps notification
        print("didReceive")
        handlePushNotification(userInfo: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // App is running in the foreground
        
//        completionHandler()
    }
}

extension Notifications {
    private enum NotificationType: String {
        case newArticle = "new_article"
        // later: add weekly debrief type
    }
}
