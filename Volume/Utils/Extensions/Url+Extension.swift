//
//  Url+Extension.swift
//  Volume
//
//  Created by Sergio Diaz on 4/26/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import Foundation

enum ValidURLHost: CaseIterable {

    case article
    case magazine

    var host: String? {
        switch self {
        case .article:
            return URL(string: Secrets.openArticleUrl)?.host
        case .magazine:
            return URL(string: Secrets.openMagazineUrl)?.host
        }
    }

}

extension URL {

    var parameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }

        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value ?? ""
        }

        return parameters
    }

    var isDeeplink: Bool {
        guard let host = self.host else { return false }
        return ValidURLHost.allCases.contains { $0.host == host }
    }

    var contentType: ValidURLHost? {
        guard let host = self.host else { return nil }
        return ValidURLHost.allCases.first { $0.host == host }
    }

}
