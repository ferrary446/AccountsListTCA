//
//  URLSessionProtocol.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

import Foundation

protocol URLSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
