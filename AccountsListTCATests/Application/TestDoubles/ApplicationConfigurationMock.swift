//
//  ApplicationConfigurationMock.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA

extension ApplicationConfiguration {
    static func makeMock(
        apiKey: String = "apiKey",
        host: String = "host"
    ) -> Self {
        ApplicationConfiguration(
            apiKey: apiKey,
            host: host
        )
    }
}
