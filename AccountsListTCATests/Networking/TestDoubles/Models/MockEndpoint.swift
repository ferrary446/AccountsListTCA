//
//  MockEndpoint.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import Foundation

enum MockEndpoint: Endpoint {
    case getRequestMock(
        body: Data?,
        headers: [String: String],
        query: [String: String]
    )

    case postRequestMock(
        body: Data?,
        headers: [String: String],
        query: [String: String]
    )

    case putRequestMock(
        body: Data?,
        headers: [String: String],
        query: [String: String]
    )

    case deleteRequestMock(
        body: Data?,
        headers: [String: String],
        query: [String: String]
    )
}

extension MockEndpoint {
    var method: HTTPMethod {
        switch self {
        case .getRequestMock:
            .get
        case .postRequestMock:
            .post
        case .putRequestMock:
            .put
        case .deleteRequestMock:
            .delete
        }
    }

    var path: String {
        "/path"
    }

    var body: Data? {
        switch self {
        case let .getRequestMock(body, _, _):
            body
        case let .postRequestMock(body, _, _):
            body
        case let .putRequestMock(body, _, _):
            body
        case let .deleteRequestMock(body, _, _):
            body
        }
    }

    var headers: [String: String] {
        switch self {
        case let .getRequestMock(_, headers, _):
            headers
        case let .postRequestMock(_, headers, _):
            headers
        case let .putRequestMock(_, headers, _):
            headers
        case let .deleteRequestMock(_, headers, _):
            headers
        }
    }

    var query: [String: String] {
        switch self {
        case let .getRequestMock(_, _, query):
            query
        case let .postRequestMock(_, _, query):
            query
        case let .putRequestMock(_, _, query):
            query
        case let .deleteRequestMock(_, _, query):
            query
        }
    }
}
