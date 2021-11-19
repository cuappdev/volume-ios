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
    
    func toString() -> String? {
        switch self {
        case .article:
            return URL(string: Secrets.openArticleUrl)?.host
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
        guard let host = self.host
        else { return false }
        for validHost in ValidURLHost.allCases {
            if host == validHost.toString() {
                return true
            }
        }
        return false
    }
}
