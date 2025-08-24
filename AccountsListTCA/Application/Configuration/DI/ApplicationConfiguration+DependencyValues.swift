//
//  ApplicationConfiguration+DependencyValues.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 23.08.2025.
//

import ComposableArchitecture

extension DependencyValues {
    enum ApplicationConfigurationDependencyKey: DependencyKey {
        static var liveValue: ApplicationConfiguration {
            @Dependency(\.configurationService) var service

            return ApplicationConfiguration(
                apiKey: service.getInformationPlistValue(key: .apiKey),
                host: service.getInformationPlistValue(key: .host)
            )
        }
    }

    var applicationConfiguration: ApplicationConfiguration {
        get { self[ApplicationConfigurationDependencyKey.self] }
        set { self[ApplicationConfigurationDependencyKey.self] = newValue }
    }
}
