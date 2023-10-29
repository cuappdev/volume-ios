//
//  LinkItemSource.swift
//  Volume
//
//  Created by Sergio Diaz on 4/27/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import LinkPresentation
import UIKit

class LinkItemSource: NSObject, UIActivityItemSource {
    private let metadata = LPLinkMetadata()
    private let url: URL
    private let item: String

    init(url: URL, article: Article) {
        item = "article"
        metadata.originalURL = url
        metadata.url = metadata.originalURL
        metadata.title = article.title
        self.url = url
    }

    init(url: URL, magazine: Magazine) {
        item = "magazine"
        metadata.originalURL = url
        metadata.url = metadata.originalURL
        metadata.title = magazine.title
        self.url = url
    }

    init(url: URL, flyer: Flyer) {
        item = "flyer"
        metadata.originalURL = url
        metadata.url = metadata.originalURL
        metadata.title = flyer.title
        self.url = url
    }

    // What is presented to user within the share view controller
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        metadata
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        "Placeholder"
    }

    // What is presented when user actually shares (i.e. like on iMessage, Twitter, etc.)
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        if let title = metadata.title {
            return """
                Check out this \(item) on Volume:

                \(title)

                \(url)
                """
        }
        return """
            Check out this \(item) on Volume!

            \(url)
            """
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        metadata.title ?? "Check out this \(item) on Volume!"
    }
}
