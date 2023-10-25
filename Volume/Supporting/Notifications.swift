//
//  Notifications.swift
//  Volume
//
//  Created by Hanzheng Li on 11/17/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import FirebaseMessaging
import SwiftUI
import UserNotifications

class Notifications: NSObject, ObservableObject {

    static let shared = Notifications()
    private let center = UNUserNotificationCenter.current()
    let firebaseMessaging = Messaging.messaging()
    @Published var isWeeklyDebriefOpen = false

    override private init() {
        super.init()
        center.delegate = self
        firebaseMessaging.delegate = self
    }

    func requestAuthorization() {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                self.center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if granted {
                        let event = VolumeEvent.enableNotification.toEvent(
                            .notification,
                            value: "",
                            navigationSource: .unspecified
                        )
                        AppDevAnalytics.log(event)
                    } else if let error = error {
                        print("Error: failed to obtain push notification permissions: \(error.localizedDescription)")
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
        #if DEBUG
        print("Notification payload userInfo: \(userInfo)")
        #endif
        guard let notificationType = userInfo["notificationType"] as? String
        else {
            #if DEBUG
            print("Error: data or notificationType not found in push notification payload")
            #endif
            return
        }
        switch notificationType {
        case NotificationType.newArticle.rawValue:
            guard let articleID = userInfo["articleID"] as? String else {
                #if DEBUG
                print("Error: missing articleID in new article notification payload")
                #endif
                break
            }
            openArticle(id: articleID)
        case NotificationType.weeklyDebrief.rawValue:
            isWeeklyDebriefOpen = true
        default:
            #if DEBUG
            print("Error: unknown notificationType: \(notificationType)")
            #endif
        }
    }

    private func openArticle(id: String) {
        guard let url = URL(string: "\(Secrets.openArticleUrl)\(id)") else { return }
        UIApplication.shared.open(url)
    }

}

extension Notifications: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // App is running in the background, user taps notification
        handlePushNotification(userInfo: response.notification.request.content.userInfo)
        completionHandler()
    }

}

extension Notifications {

    private enum NotificationType: String {
        case newArticle = "new_article"
        case weeklyDebrief = "weekly_debrief"
    }

}

extension Notifications: MessagingDelegate {

    @MainActor func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            #if DEBUG
            print("Firebase Messaging registration token: \(fcmToken)")
            #endif
            UserData.shared.fcmToken = fcmToken
        } else {
            #if DEBUG
            print("Error: Firebase Messaging failed to register")
            #endif
            UserData.shared.fcmToken = "debugSimulatorFCMToken"
        }

        let tokenDict = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict
        )
    }

}
