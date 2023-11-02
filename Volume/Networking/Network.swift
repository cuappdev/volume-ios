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

/// Provides an API to create Publishers that execute GraphQL requests and return responses via ApolloClient
class Network {
    static let shared = Network()
    private let apollo = ApolloClient(url: Secrets.endpointGraphQL)

    /// Create a Publisher using a GraphQLQuery
    func publisher<Query: GraphQLQuery>(for query: Query) -> OperationPublisher<Query.Data> {
        OperationPublisher<Query.Data>(client: apollo, operation: QueryOperation(query: query).asAny)
    }

    /// Create a Publisher using a GraphQLMutation
    /// - For mutations whose response can be discarded, use apollo.perform(mutation:)
    func publisher<Mutation: GraphQLMutation>(for mutation: Mutation) -> OperationPublisher<Mutation.Data> {
        OperationPublisher<Mutation.Data>(client: apollo, operation: MutationOperation(mutation: mutation).asAny)
    }

    func clearCache() {
        apollo.clearCache()
    }
}

enum WrappedGraphQLError: Error {
    case graphQL([GraphQLError])
    case some(Error)
    case noData
}

// MARK: Operation

/*
 The following 4 declarations (Operation, QueryOperation, MutationOperation, AnyOperation)
 take advantage of "type erasure" to allow the same
 Combine Publisher/Subscription functions to be applied on values of type GraphQLQuery
 and GraphQLMutation, without duplicating implementation.
 */
private protocol Operation {
    associatedtype Data
    typealias Handler = (Result<GraphQLResult<Data>, Error>) -> Void

    func execute(client: ApolloClient, resultHandler: @escaping Handler)
}

extension Operation {
    var asAny: AnyOperation<Data> { AnyOperation(execute: execute) }
}

private struct QueryOperation<Q: GraphQLQuery>: Operation {
    typealias Data = Q.Data

    let query: Q

    func execute(client: ApolloClient, resultHandler: @escaping (Result<GraphQLResult<Q.Data>, Error>) -> Void) {
        client.fetch(query: query, resultHandler: resultHandler)
    }
}

private struct MutationOperation<M: GraphQLMutation>: Operation {
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

// MARK: OperationPublisher

struct OperationPublisher<Data>: Publisher {
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
        let subscription = OperationSubscription(client: client, operation: operation, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: OperationSubscription

private class OperationSubscription<Data, S: Subscriber>: Subscription
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
    @Published var networkScreenFailed: [Screen: Bool] = [:]

    public enum Screen: String, CaseIterable {
        case trending, flyers, reads, publications, bookmarks, publicationDetail, search
    }

    func handleCompletion(screen: Screen, _ completion: Subscribers.Completion<WrappedGraphQLError>) {
        if case let .failure(error) = completion {
            networkScreenFailed[screen] = true
            print("Error on \(screen.rawValue): \(error)")
        } else {
            networkScreenFailed[screen] = false
        }
    }

    func networkDidFail(on screen: Screen) -> Bool {
        networkScreenFailed[screen] ?? false
    }
}
