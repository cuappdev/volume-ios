//
//  Analytics.swift
//  Volume
//
//  Created by Conner Swenberg on 2/23/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics

/// Volume-specific extensions of base Event protocol
struct AnyEvent: Event {
    let name: String
    let parameters: [String: Any]?
}

enum VolumeEvent: String {
    // General events
    case announcementPresented = "announcement_presented"
    case startOnboarding = "start_onboarding"
    case completeOnboarding = "complete_onboarding"
    
    // Publication-specific events
    case followPublication = "follow_publication"
    case unfollowPublication = "unfollow_publication"
    
    // Article-specific events
    case openArticle = "open_article"
    case shareArticle = "share_article"
    case shoutoutArticle = "shoutout_article"
    case bookmarkArticle = "bookmark_article"
    
    // Notification-specific events
    case clickNotification = "click_notification"
    case enableNotification = "enable_notification"
    case notificationIntervalClose = "notification_interval_close"
    
    // Magazine-specific events
    case openMagazine = "open_magazine"
    case shareMagazine = "share_magazine"
    case shoutoutMagazine = "shoutout_magazine"
    case bookmarkMagazine = "bookmark_magazine"
    
    // Flyer-specific events
    case openFlyer = "open_flyer"
    case shareFlyer = "share_flyer"
    case bookmarkFlyer = "bookmark_flyer"
    
    enum EventType {
        case article, flyer, general, magazine, notification, notificationInterval, publication
    }

    func toEvent(_ event: EventType, value: String = "", navigationSource: NavigationSource = .unspecified) -> AnyEvent {
        var parameters: [String: Any]
        switch event {
        case .article:
            parameters = ["articleID": value]
        case .flyer:
            parameters = ["flyerID": value]
        case .magazine:
            parameters = ["magazineID": value]
        case .notificationInterval:
            parameters = ["duration": value]
        case .publication:
            parameters = ["publicationSlug": value]
        default:
            parameters = [:]
        }
        parameters["navigationSource"] = navigationSource.rawValue
        parameters["userID"] = UIDevice.current.identifierForVendor?.uuidString
        return AnyEvent(name: rawValue, parameters: parameters)
    }
}

enum NavigationSource: String {
    // General Entry Points
    case onboarding = "onboarding"
    case trending = "trending"

    // Article Entry Points
    case bookmarkArticles = "bookmark_articles"
    case followingArticles = "following_articles"
    case otherArticles = "other_articles"
    case publicationDetail = "publication_detail"
    case searchArticles = "search_articles"
    case trendingArticles = "trending_articles"
    case pushNotification = "push_notification"
    case weeklyDebrief = "weekly_debrief"
    
    // Magazine Entry Points
    case bookmarkMagazines = "bookmark_magazines"
    case featuredMagazines = "featured_magazines"
    case moreMagazines = "more_magazines"
    case searchMagazines = "search_magazines"
    
    // Publication Entry Points
    case articleDetail = "article_detail"
    case followingPublications = "following_publications"
    case morePublications = "more_publications"
    case magazineDetail = "magazine_detail"
    
    // Flyer Entry Points
    case bookmarkFlyers = "bookmark_flyers"
    case flyersTab = "flyers_tab"
    case searchFlyers = "search_flyers"

    case unspecified
}
