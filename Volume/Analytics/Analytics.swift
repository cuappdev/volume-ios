//
//  Analytics.swift
//  Volume
//
//  Created by Conner Swenberg on 2/23/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics

/// volume-specific extensions of base Event protocol
struct AnyEvent: Event {
    let name: String
    let parameters: [String: Any]?
}

enum VolumeEvent: String {
    /// General events
    case announcementPresented = "announcement_presented"
    case startOnboarding = "start_onboarding"
    case completeOnboarding = "complete_onboarding"
    /// Publication-specific events
    case followPublication = "follow_publication"
    case unfollowPublication = "unfollow_publication"
    /// Article-specific events
    case openArticle = "open_article"
    case closeArticle = "close_article"
    case shareArticle = "share_article"
    case shoutoutArticle = "shoutout_article"
    case bookmarkArticle = "bookmark_article"
    case unbookmarkArticle = "unbookmark_article"
    /// Notification-specific events
    case clickNotification = "click_notification"
    case enableNotification = "enable_notification"
    case notificationIntervalClose = "notification_interval_close"
    
    enum EventType {
        case article, general, publication, notification, notificationInterval
    }

    func toEvent(_ event: EventType, value: String = "", navigationSource: NavigationSource = .unspecified) -> AnyEvent {
        var parameters: [String: Any]
        switch event {
        case .article:
            parameters = ["articleID": value]
        case .publication:
            // TODO: replace analytics instances of publicationID with publicationSlug
            parameters = ["publicationID": value]
        case .notificationInterval:
            parameters = ["duration": value]
        default:
            parameters = [:]
        }
        parameters["navigationSource"] = navigationSource.rawValue
        parameters["userID"] = UIDevice.current.identifierForVendor?.uuidString
        return AnyEvent(name: rawValue, parameters: parameters)
    }
}

enum NavigationSource: String {
    // Article Entry Points
    case bookmarkArticles = "bookmark_articles"
    case followingArticles = "following_articles"
    case otherArticles = "other_articles"
    case publicationDetail = "publication_detail"
    case trendingArticles = "trending_articles"
    case pushNotification = "push_notification"
    case weeklyDebrief = "weekly_debrief"
    
    // Publication Entry Points
    case articleDetail = "article_detail"
    case followingPublications = "following_publications"
    case morePublications = "more_publications"
    case onboarding = "onboarding"

    case unspecified
}
