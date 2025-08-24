//
//  NetworkingErrorConverter+DependencyValues.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture

extension DependencyValues {
    enum NetworkingErrorConverterDependencyKey: DependencyKey {
        static var liveValue: any NetworkingErrorConverter {
            NetworkingErrorConverterImp()
        }
    }

    var networkingErrorConverter: NetworkingErrorConverter {
        get { self[NetworkingErrorConverterDependencyKey.self] }
        set { self[NetworkingErrorConverterDependencyKey.self] = newValue }
    }
}
