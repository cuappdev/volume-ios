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
    let metadata: LPLinkMetadata
    let rawUrlString: String

    init(url: URL, article: Article) {
        metadata = LPLinkMetadata()
        metadata.originalURL = url
        metadata.url = metadata.originalURL
        metadata.title = article.title
        rawUrlString = url.absoluteString
    }

    // What is presented to user within the share view controller
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        metadata
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        "Placeholder"
    }

    // What is presented when user actually shares (i.e. like on iMessage, Twitter, etc.)
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        let lineBreak = "\n\n"
        if let title = metadata.title {
            return "Check out this article on Volume:" + lineBreak + title + lineBreak + rawUrlString
        }
        return "Check out this article on Volume!" + lineBreak + rawUrlString
    }

    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        metadata.title ?? "Check out this article on Volume!"
    }

}
