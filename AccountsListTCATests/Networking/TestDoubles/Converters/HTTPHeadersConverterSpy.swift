//
//  HTTPHeadersConverterSpy.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import ComposableArchitecture

final class HTTPHeadersConverterSpy: HTTPHeadersConverter, @unchecked Sendable {
    struct Call {
        let apiKey: String
        let headers: [String: String]
    }

    private(set) var calls = [Call]()

    private let convertReturn: [String: String]

    init(convertReturn: [String: String] = [:]) {
        self.convertReturn = convertReturn
    }

    func convert(
        apiKey: String,
        headers: [String: String]
    ) -> [String: String] {
        calls.append(Call(apiKey: apiKey, headers: headers))

        return convertReturn
    }
}
