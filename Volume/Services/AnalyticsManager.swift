//
//  AnalyticsManager.swift
//  Volume
//
//  Created by Vin Bui on 3/30/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import FirebaseAnalytics
import OSLog

/// Manage Volume's Google Analytics.
class AnalyticsManager {

    /// Shared singleton instance.
    static let shared = AnalyticsManager()

    private init() {}

    /// Log an event to Google Analytics.
    func log(_ event: Event) {
#if !DEBUG
        Analytics.logEvent(event.name, parameters: event.parameters)
#else
        // Uncomment below to debug
        //        Logger.statistics.info(
        //            "[DEBUG] Logged event: \(event.name), params: \(event.parameters?.description ?? "nil")"
        //        )
#endif
    }

}

/// An enumeration representing entry points for a Volume event.
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

    // Orgs Admin Entry Points
    case orgsAdmin = "orgs_admin"

    case unspecified

}

/// A structure that represents a Google Analytics event.
struct Event {

    /// The name of the event.
    let name: String

    /// The parameters to pass in to this event.
    let parameters: [String: Any]?

}

/// An enumeration representing a Volume event.
enum VolumeEvent: String {

    // Page click events
    case tapTrendingPage = "tap_trending_page"
    case tapFlyersPage = "tap_flyers_page"
    case tapReadsPage = "tap_reads_page"
    case tapBookmarksPage = "tap_bookmarks_page"

    // General events
    case announcementPresented = "announcement_presented"
    case startOnboarding = "start_onboarding"
    case completeOnboarding = "complete_onboarding"

    // Publication-specific events
    case followPublication = "follow_publication"
    case unfollowPublication = "unfollow_publication"

    // Organization-specific events
    case followOrganization = "follow_organization"
    case unfollowOrganization = "unfollow_organization"

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
        case article
        case flyer
        case general
        case magazine
        case notification
        case notificationInterval
        case organization
        case publication
        case page
    }

    /**
     Retrieve an `Event` object for this custom event.

     Do not pass in any parameters to this function if no parameters are tracked for this event.

     - Parameters:
     - type: The type of the event to track used as the parameter key.
     - value: The value for the parameter key.

     - Returns: An `Event` to be tracked in Google Analytics.
     */
    func toEvent(
        type: EventType? = nil,
        value: String? = nil,
        navigationSource: NavigationSource = .unspecified
    ) -> Event {
        // No Parameters
        guard let type,
              let value else { return Event(name: rawValue, parameters: nil) }

        // With Parameters
        var parameters: [String: Any]
        switch type {
        case .article:
            parameters = ["articleID": value]
        case .flyer:
            parameters = ["flyerID": value]
        case .magazine:
            parameters = ["magazineID": value]
        case .notificationInterval:
            parameters = ["duration": value]
        case .organization:
            parameters = ["organizationSlug": value]
        case .publication:
            parameters = ["publicationSlug": value]
        default:
            parameters = [:]
        }

        parameters["navigationSource"] = navigationSource.rawValue
        parameters["userID"] = UIDevice.current.identifierForVendor?.uuidString

        return Event(name: rawValue, parameters: parameters)
    }

}
