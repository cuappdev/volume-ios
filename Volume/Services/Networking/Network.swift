//
//  Network.swift
//  Volume
//
//  Created by Vin Bui on 3/30/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Apollo
import Combine
import Foundation
import OSLog

/// An API that used Combine Publishers to execute GraphQL requests and return responses via ApolloClient.
final class Network {

    /// The Apollo client.
    static let client = ApolloClient(url: Secrets.endpointGraphQL)

}

class NetworkState: ObservableObject {

    @Published var networkScreenFailed: [Screen: Bool] = [:]

    enum Screen: String, CaseIterable {
        case bookmarks, flyers, publicationDetail, reads, search, trending
    }

    func handleCompletion(screen: Screen, _ completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            networkScreenFailed[screen] = true
            Logger.services.critical("Error on \(screen.rawValue): \(error)")
        } else {
            networkScreenFailed[screen] = false
        }
    }

    func networkDidFail(on screen: Screen) -> Bool {
        networkScreenFailed[screen] ?? false
    }

}
