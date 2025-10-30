//
//  ConfigurationServiceSpy.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

import ComposableArchitecture

final class ConfigurationServiceSpy: ConfigurationServiceful, @unchecked Sendable {
    struct Call {
        let key: ConfigurationKeys
    }

    private(set) var calls = [Call]()

    private let convertReturn: [ConfigurationKeys: String]

    init(convertReturn: [ConfigurationKeys: String] = [:]) {
        self.convertReturn = convertReturn
    }

    func getInformationPlistValue(key: ConfigurationKeys) -> String {
        calls.append(Call(key: key))

        return convertReturn[key, default: ""]
    }
}
