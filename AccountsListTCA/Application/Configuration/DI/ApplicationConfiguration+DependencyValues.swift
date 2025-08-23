//
//  ApplicationConfiguration+DependencyValues.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 23.08.2025.
//

import ComposableArchitecture

extension DependencyValues {
    enum ApplicationConfigurationDependencyKey: DependencyKey {
        static let liveValue: ApplicationConfiguration = .live
    }

    var applicationConfiguration: ApplicationConfiguration {
        get { self[ApplicationConfigurationDependencyKey.self] }
        set { self[ApplicationConfigurationDependencyKey.self] = newValue }
    }
}

extension ApplicationConfiguration {
    static var live: Self {
        @Dependency(\.configurationService) var service

        return ApplicationConfiguration(
            apiKey: service.getInformationPlistValue(key: .apiKey),
            baseURL: service.getInformationPlistValue(key: .baseURL)
        )
    }
}
