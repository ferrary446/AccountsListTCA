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
            @Dependency(\.configurationService) var service
            @Dependency(\.httpHeadersConverter) var converter

            return NetworkingService(
                converter: converter,
                service: service
            )
        }

        static var testValue: any NetworkingServiceful {
            NetworkingServiceSpy()
        }
    }

    var networkingService: NetworkingServiceful {
        get { self[NetworkingServiceDependencyKey.self] }
        set { self[NetworkingServiceDependencyKey.self] = newValue }
    }
}
