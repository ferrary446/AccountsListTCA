//
//  HTTPHeadersConverter+DependencyValues.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture

extension DependencyValues {
    enum HTTPHeadersConverterDependencyKey: DependencyKey {
        static var liveValue: any HTTPHeadersConverter {
            HTTPHeadersConverterImp()
        }

        static var testValue: any HTTPHeadersConverter {
            HTTPHeadersConverterSpy()
        }
    }

    var httpHeadersConverter: HTTPHeadersConverter {
        get { self[HTTPHeadersConverterDependencyKey.self] }
        set { self[HTTPHeadersConverterDependencyKey.self] = newValue }
    }
}
