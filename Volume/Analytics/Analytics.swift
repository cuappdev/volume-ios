//
//  Analytics.swift
//  Volume
//
//  Created by Conner Swenberg on 2/23/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics

// volume-specific extensions of base Event protocol
struct StartOnboarding: Event {
    let name = "start_onboarding"
}

struct CompleteOnboarding: Event {
    let name = "complete_onboarding"
}

struct FollowPublication: Event {
    let name = "follow_publication"
    var parameters: [String : Any]?
}

struct UnfollowPublication: Event {
    let name = "unfollow_publication"
    var parameters: [String : Any]?
}

struct OpenArticle: Event {
    let name = "open_article"
    var parameters: [String : Any]?
}

struct CloseArticle: Event {
    let name = "close_article"
    var parameters: [String : Any]?
}

struct ShareArticle: Event {
    let name = "share_article"
    var parameters: [String : Any]?
}

struct ShoutoutArticle: Event {
    let name = "shoutout_article"
    var parameters: [String : Any]?
}

struct BookmarkArticle: Event {
    let name = "bookmark_article"
    var parameters: [String : Any]?
}

struct UnbookmarkArticle: Event {
    let name = "unbookmark_article"
    var parameters: [String : Any]?
}

// Helper struct and enums to disambiguate parameters for different event types
struct Parameters {
    static func params(for event: EventLevel, id: String, at entry: EntryPoint) -> [String: Any] {
        switch event {
        case .article:
            return ["articleID": id, "entryPoint": entry.rawValue]
        case .publication:
            return ["publicationID": id, "entryPoint": entry.rawValue]
        }
    }
}

enum EntryPoint: String {
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
}

enum EventLevel {
    case article
    case publication
}
