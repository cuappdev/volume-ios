//
//  Keys.swift
//  Volume
//
//  Created by Daniel Vebman on 12/7/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Secrets {
    // swiftlint:disable force_cast
    #if DEBUG
    static let endpoint = URL(string: keyDict["graphql-endpoint-debug"] as! String)!
    #else
    static let endpoint = URL(string: keyDict["graphql-endpoint-production"] as! String)!
    #endif
    // swiftlint:enable force_cast

    static let announcementsCommonPath = Secrets.keyDict["announcements-common-path"] as! String
    static let announcementsHost = Secrets.keyDict["announcements-host"] as! String
    static let announcementsPath = Secrets.keyDict["announcements-path"] as! String
    static let announcementsScheme = Secrets.keyDict["announcements-scheme"] as! String
    static let appdevWebsite = Secrets.keyDict["appdev-website"] as! String
    static let feedbackForm = Secrets.keyDict["feedback-form"] as! String
    static let openArticleUrl = Secrets.keyDict["openarticle-url"] as! String
    static let openMagazineUrl = Secrets.keyDict["openmagazine-url"] as! String

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path)
        else { return [:] }
        return dict
    }()
}
