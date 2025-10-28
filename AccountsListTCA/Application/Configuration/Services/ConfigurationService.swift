//
//  ConfigurationService.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 23.08.2025.
//

import Foundation

protocol ConfigurationServiceful: Sendable {
    func getInformationPlistValue(key: ConfigurationKeys) throws -> String
}

struct ConfigurationService: ConfigurationServiceful {
    enum ConfigurationError: Error {
        case searchingError
        case transformingError
    }

    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func getInformationPlistValue(key: ConfigurationKeys) throws -> String {
        guard let informationPlist = bundle.infoDictionary else {
            throw ConfigurationError.searchingError
        }

        if let value = informationPlist[key.rawValue] as? String {
            return value
        } else {
            throw ConfigurationError.transformingError
        }
    }
}
