//
//  ConfigurationService+DependencyValues.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 23.08.2025.
//

import ComposableArchitecture

extension DependencyValues {
    enum ConfigurationServiceDependencyKey: DependencyKey {
        static let liveValue: ConfigurationServiceful = ConfigurationService()
    }

    var configurationService: ConfigurationServiceful {
        get { self[ConfigurationServiceDependencyKey.self] }
        set { self[ConfigurationServiceDependencyKey.self] = newValue }
    }
}
