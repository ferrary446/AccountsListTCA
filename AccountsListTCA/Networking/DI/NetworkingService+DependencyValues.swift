//
//  NetworkingService+DependencyValues.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture

extension DependencyValues {
    enum NetworkingServiceDependencyKey: DependencyKey {
        static var liveValue: any NetworkingServiceful {
            @Dependency(\.applicationConfiguration) var configuration
            @Dependency(\.httpHeadersConverter) var converter

            return NetworkingService(
                configuration: configuration,
                converter: converter
            )
        }
    }

    var networkingService: NetworkingServiceful {
        get { self[NetworkingServiceDependencyKey.self] }
        set { self[NetworkingServiceDependencyKey.self] = newValue }
    }
}
