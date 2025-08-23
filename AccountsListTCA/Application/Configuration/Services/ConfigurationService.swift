//
//  ConfigurationService.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 23.08.2025.
//

import Foundation

protocol ConfigurationServiceful {
    func getInformationPlistValue(key: ConfigurationKeys) -> String
}

struct ConfigurationService: ConfigurationServiceful {
    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func getInformationPlistValue(key: ConfigurationKeys) -> String {
        guard let informationPlist = bundle.infoDictionary else {
            fatalError("Can not search information plist value by key: \(key.rawValue)")
        }

        if let value = informationPlist[key.rawValue] as? String {
            return value
        } else {
            fatalError("Can not transform value to string with key: \(key.rawValue)")
        }
    }
}
