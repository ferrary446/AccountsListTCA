//
//  Endpoint.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import Foundation

protocol Endpoint {
    var body: Data? { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var query: [String: String] { get }
}

extension Endpoint {
    var body: Data? {
        nil
    }

    var headers: [String: String] {
        [:]
    }

    var query: [String: String] {
        [:]
    }
}
