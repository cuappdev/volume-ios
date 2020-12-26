//
//  Network.swift
//  Volume
//
//  Created by Daniel Vebman on 11/22/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Apollo
import Combine
import Foundation

class Network {
    static let shared = Network()
    let apollo = ApolloClient(url: Secrets.endpoint)
}

extension ApolloClient {
    func fetch<Query: GraphQLQuery>(query: Query) -> GraphQLPublisher<Query> {
        GraphQLPublisher(client: self, query: query)
    }
}

enum WrappedGraphQLError: Error {
    case graphQL([GraphQLError])
    case some(Error)
    case noData
}

class GraphQLSubscription<Query: GraphQLQuery, S: Subscriber>:
    Subscription where S.Input == Query.Data, S.Failure == WrappedGraphQLError {
    
    private let client: ApolloClient
    private let query: Query
    private var cancellableQuery: Apollo.Cancellable?
    private var subscriber: S?
    
    init(client: ApolloClient, query: Query, subscriber: S) {
        self.client = client
        self.query = query
        self.subscriber = subscriber
        fetchQuery()
    }
    
    func request(_ demand: Subscribers.Demand) { }
    
    func cancel() {
        subscriber = nil
        cancellableQuery?.cancel()
    }
    
    private func fetchQuery() {
        guard let subscriber = subscriber else { return }
        cancellableQuery = client.fetch(query: query) { result in
            switch result {
            case .success(let result):
                if let errors = result.errors {
                    subscriber.receive(completion: .failure(.graphQL(errors)))
                } else if let data = result.data {
                    _ = subscriber.receive(data)
                } else {
                    subscriber.receive(completion: .failure(.noData))
                }
            case .failure(let error):
                subscriber.receive(completion: .failure(.some(error)))
            }
        }
    }
}

struct GraphQLPublisher<Query: GraphQLQuery>: Publisher {
    typealias Output = Query.Data
    typealias Failure = WrappedGraphQLError
    
    private let client: ApolloClient
    private let query: Query
    
    init(client: ApolloClient, query: Query) {
        self.client = client
        self.query = query
    }
    
    func receive<S>(
        subscriber: S
    ) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = GraphQLSubscription(client: client, query: query, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}
