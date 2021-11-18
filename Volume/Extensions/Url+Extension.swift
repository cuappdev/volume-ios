//
//  Url+Extension.swift
//  Volume
//
//  Created by Sergio Diaz on 4/26/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import Foundation

enum ValidURLHost {
    case article
    
    func toString() -> String? {
        switch self {
        case .article:
            let url = URL(string: Secrets.openArticleUrl)
            return url?.host
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
        switch host {
        case ValidURLHost.article.toString():
            return true
        default:
            return false
        }
    }
}
