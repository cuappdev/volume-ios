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

/// Provides an API to create Publishers of GraphQL responses via Apollo
extension ApolloClient {
    /// Create a Publisher using a GraphQLQuery
    func publisher<Query: GraphQLQuery>(for query: Query) -> GraphQLOperationPublisher<Query.Data> {
        GraphQLOperationPublisher<Query.Data>(client: self, operation: QueryOperation(query: query).toAny())
    }
    
    /// Create a Publisher using a GraphQLMutation
    /// - For mutations whose response can be discarded, use ApolloClient.perform(mutation:)
    func publisher<Mutation: GraphQLMutation>(for mutation: Mutation) -> GraphQLOperationPublisher<Mutation.Data> {
        GraphQLOperationPublisher<Mutation.Data>(client: self, operation: MutationOperation(mutation: mutation).toAny())
    }
}

enum WrappedGraphQLError: Error {
    case graphQL([GraphQLError])
    case some(Error)
    case noData
}

// MARK: Operation

// The following 4 declarations (Operation, QueryOperation, MutationOperation, AnyOperation) take advantage of "type erasure" to allow the same Combine Publisher/Subscription functions to be applied on values of type GraphQLQuery and GraphQLMutation, without duplicating function signatures.
private protocol Operation {
    associatedtype Data
    typealias Handler = (Result<GraphQLResult<Data>, Error>) -> Void
    
    func execute(client: ApolloClient, resultHandler: @escaping Handler)
    
    func toAny() -> AnyOperation<Data>
}

private struct QueryOperation<Q: GraphQLQuery>: Operation {
    typealias Data = Q.Data
    
    let query: Q
    
    func execute(client: ApolloClient, resultHandler: @escaping (Result<GraphQLResult<Q.Data>, Error>) -> Void) {
        client.fetch(query: query, resultHandler: resultHandler)
    }
    
    func toAny() -> AnyOperation<Data> {
        return AnyOperation(execute: self.execute)
    }
}

private struct MutationOperation<M: GraphQLMutation>: Operation {
    typealias Data = M.Data
    
    let mutation: M
    
    func execute(client: ApolloClient, resultHandler: @escaping (Result<GraphQLResult<M.Data>, Error>) -> Void) {
        client.perform(mutation: mutation, resultHandler: resultHandler)
    }
    
    func toAny() -> AnyOperation<Data> {
        return AnyOperation(execute: self.execute)
    }
}

struct AnyOperation<Data> {
    typealias Handler = (Result<GraphQLResult<Data>, Error>) -> Void
    
    let execute: (ApolloClient, @escaping Handler) -> Void
}

// MARK: GraphQLOperationPublisher

struct GraphQLOperationPublisher<Data>: Publisher {
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
        let subscription = GraphQLOperationSubscription(client: client, operation: operation, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: GraphQLOperationSubscription

private class GraphQLOperationSubscription<Data, S: Subscriber>: Subscription
    where S.Input == Data, S.Failure == WrappedGraphQLError {

    private let client: ApolloClient
    private let operation: AnyOperation<Data>
    private var cancellableOperation: Apollo.Cancellable?
    private var subscriber: S?

    init(client: ApolloClient, operation: AnyOperation<Data>, subscriber: S) {
        self.client = client
        self.operation = operation
        self.subscriber = subscriber
        executeOperation()
    }

    func request(_ demand: Subscribers.Demand) { }

    func cancel() {
        subscriber = nil
        cancellableOperation?.cancel()
    }

    private func executeOperation() {
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
