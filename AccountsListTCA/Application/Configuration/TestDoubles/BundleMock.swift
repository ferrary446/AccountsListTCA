//
//  BundleMock.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

import Foundation

final class BundleMock: Bundle, @unchecked Sendable {
    private let infoDictionaryReturn: [String: Any]?

    init(infoDictionaryReturn: [String: Any]? = [:]) {
        self.infoDictionaryReturn = infoDictionaryReturn

        super.init()
    }

    override var infoDictionary: [String: Any]? {
        infoDictionaryReturn
    }
}
