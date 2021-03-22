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
    
    enum EventType {
        case article, general, publication
    }

    func toEvent(_ event: EventType, id: String = "error", navigationSource: NavigationSource = .unspecified) -> AnyEvent {
        let parameters: [String: Any]
        switch event {
        case .article:
            parameters = ["articleID": id, "entryPoint": navigationSource.rawValue]
        case .publication:
            parameters = ["publicationID": id, "entryPoint": navigationSource.rawValue]
        default:
            parameters = [:]
        }
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
    
    // Publication Entry Points
    case articleDetail = "article_detail"
    case followingPublications = "following_publications"
    case morePublications = "more_publications"
    case onboarding = "onboarding"
    
    case unspecified
}

// Helper struct and enums to disambiguate parameters for different event types
//struct Parameters {
//    static func create(_ event: EventType, id: String, at entry: NavigationSource) -> [String: Any] {
//
//    }
//}



//enum EventType {
//    case article, publication
//}



//struct StartOnboarding: Event {
//    let name = "start_onboarding"
//}
//
//struct CompleteOnboarding: Event {
//    let name = "complete_onboarding"
//}
//
//struct FollowPublication: Event {
//    let name = "follow_publication"
//    let parameters: [String: Any]?
//}
//
//struct UnfollowPublication: Event {
//    let name = "unfollow_publication"
//    let parameters: [String: Any]?
//}
//
//struct OpenArticle: Event {
//    let name = "open_article"
//    let parameters: [String: Any]?
//}
//
//struct CloseArticle: Event {
//    let name = "close_article"
//    let parameters: [String: Any]?
//}
//
//struct ShareArticle: Event {
//    let name = "share_article"
//    let parameters: [String: Any]?
//}
//
//struct ShoutoutArticle: Event {
//    let name = "shoutout_article"
//    let parameters: [String: Any]?
//}
//
//struct BookmarkArticle: Event {
//    let name = "bookmark_article"
//    let parameters: [String: Any]?
//}
//
//struct UnbookmarkArticle: Event {
//    let name = "unbookmark_article"
//    let parameters: [String: Any]?
//}
