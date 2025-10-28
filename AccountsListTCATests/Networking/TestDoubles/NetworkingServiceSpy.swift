//
//  NetworkingServiceSpy.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import ComposableArchitecture

final class NetworkingServiceSpy: NetworkingServiceful, @unchecked Sendable {
    struct Call {
        let endpoint: Endpoint
    }

    private(set) var calls = [Call]()

    private let convertReturn: any Decodable

    init(convertReturn: any Decodable = MockResponse()) {
        self.convertReturn = convertReturn
    }

    func run<R: Decodable>(endpoint: Endpoint) async throws -> R {
        calls.append(Call(endpoint: endpoint))

        guard let result = convertReturn as? R else {
            fatalError("NetworkingServiceSpy: convertReturn is not of expected type \(R.self)")
        }

        return result
    }
}

extension DependencyValues.NetworkingServiceDependencyKey {
    static var testValue: any NetworkingServiceful {
        NetworkingServiceSpy()
    }
}
