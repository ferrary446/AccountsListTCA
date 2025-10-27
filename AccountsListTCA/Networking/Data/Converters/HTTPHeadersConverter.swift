//
//  HTTPHeadersConverter.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

protocol HTTPHeadersConverter {
    func convert(
        apiKey: String,
        headers: [String: String]
    ) -> [String: String]
}

struct HTTPHeadersConverterImp: HTTPHeadersConverter {
    func convert(
        apiKey: String,
        headers: [String: String]
    ) -> [String: String] {
        var baseHeaders = [String: String]()

        baseHeaders["Accept"] = "application/json"
        baseHeaders["WEB-API-key"] = apiKey

        headers.forEach { key, value in
            baseHeaders[key] = value
        }

        return baseHeaders
    }
}
