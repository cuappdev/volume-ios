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

// MARK: Network

class Network {
    static let shared = Network()
    let apollo = ApolloClient(url: Secrets.endpoint)
}

extension ApolloClient {
    func publisher<Query: GraphQLQuery>(for query: Query) -> GraphQLPublisher<Query.Data> {
        let operation = QueryOperation(query: query)
        let anyOperation = AnyOperation(execute: operation.execute)
        return GraphQLPublisher<Query.Data>(client: self, operation: anyOperation)
    }
    
    func publisher<Mutation: GraphQLMutation>(for mutation: Mutation) -> GraphQLPublisher<Mutation.Data> {
        let operation = MutationOperation(mutation: mutation)
        let anyOperation = AnyOperation(execute: operation.execute)
        return GraphQLPublisher<Mutation.Data>(client: self, operation: anyOperation)
    }
}

enum WrappedGraphQLError: Error {
    case graphQL([GraphQLError])
    case some(Error)
    case noData
}

// MARK: Operation

private protocol Operation {
    associatedtype Data
    typealias Handler = (Result<GraphQLResult<Data>, Error>) -> Void
    
    func execute(client: ApolloClient, resultHandler: @escaping Handler)
}

private struct QueryOperation<Q: GraphQLQuery>: Operation {
    typealias Data = Q.Data
    
    let query: Q
    
    func execute(client: ApolloClient, resultHandler: @escaping (Result<GraphQLResult<Q.Data>, Error>) -> Void) {
        client.fetch(query: query, resultHandler: resultHandler)
    }
}

struct MutationOperation<M: GraphQLMutation>: Operation {
    typealias Data = M.Data
    
    let mutation: M
    
    func execute(client: ApolloClient, resultHandler: @escaping (Result<GraphQLResult<M.Data>, Error>) -> Void) {
        client.perform(mutation: mutation, resultHandler: resultHandler)
    }
}

struct AnyOperation<Data> {
    typealias Handler = (Result<GraphQLResult<Data>, Error>) -> Void
    
    let execute: (ApolloClient, @escaping Handler) -> Void
}

// MARK: GraphQLSubscription

class GraphQLSubscription<Data, S: Subscriber>: Subscription
    where S.Input == Data, S.Failure == WrappedGraphQLError {

    private let client: ApolloClient
    private let operation: AnyOperation<Data>
    private var cancellableQuery: Apollo.Cancellable?
    private var subscriber: S?

    init(client: ApolloClient, operation: AnyOperation<Data>, subscriber: S) {
        self.client = client
        self.operation = operation
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
        operation.execute(client, { result in
            switch result {
            case .success(let result):
                if let errors = result.errors {
                    subscriber.receive(completion: .failure(.graphQL(errors)))
                } else if let data = result.data {
                    _ = subscriber.receive(data)
                    subscriber.receive(completion: .finished)
                } else {
                    subscriber.receive(completion: .failure(.noData))
                }
            case .failure(let error):
                subscriber.receive(completion: .failure(.some(error)))
            }
        })
    }
}

// MARK: GraphQLPublisher

struct GraphQLPublisher<Data>: Publisher {
    typealias Output = Data
    typealias Failure = WrappedGraphQLError

    private let client: ApolloClient
    private let operation: AnyOperation<Data>

    init(client: ApolloClient, operation: AnyOperation<Data>) {
        self.client = client
        self.operation = operation
    }

    func receive<S>(subscriber: S)
        where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = GraphQLSubscription(client: client, operation: operation, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: NetworkState

class NetworkState: ObservableObject {
    @Published var networkScreenFailed: [Screen : Bool] = [:]

    public enum Screen: CaseIterable {
        case homeList, publicationList, bookmarksList
    }

    func handleCompletion(screen: Screen, _ completion: Subscribers.Completion<WrappedGraphQLError>) {
        if case let .failure(error) = completion {
            networkScreenFailed[screen] = true
            print(error.localizedDescription)
        } else {
            networkScreenFailed[screen] = false
        }
    }

    func networkDidFail(on screen: Screen) -> Bool {
        networkScreenFailed[screen] ?? false
    }
}
