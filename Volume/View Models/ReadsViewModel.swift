//
//  ReadsViewModel.swift
//  Volume
//
//  Created by Vin Bui on 4/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension ReadsView {

    @MainActor
    class ViewModel: ObservableObject {
        // MARK: - Properties

        @Published var deeplinkID: String?
        @Published var openArticleFromDeeplink: Bool = false
        @Published var openMagazineFromDeeplink: Bool = false
        @Published var selectedTab: FilterContentType = .articles

        // MARK: - Deeplink

        func handleURL(_ url: URL) {
            if url.isDeeplink {
                let id = url.parameters["id"]
                deeplinkID = id
                switch url.contentType {
                case .article:
                    openArticleFromDeeplink = true
                case .magazine:
                    openMagazineFromDeeplink = true
                case .none:
                    break
                }
            }
        }

    }

}
