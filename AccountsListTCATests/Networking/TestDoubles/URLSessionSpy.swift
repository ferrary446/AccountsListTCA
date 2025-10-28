//
//  URLSessionSpy.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import Foundation

final class URLSessionSpy: URLSessionProtocol, @unchecked Sendable {
    struct Call {
        let request: URLRequest
    }

    private(set) var calls = [Call]()

    private let mockData: Data
    private let mockResponse: URLResponse
    private let mockError: Error?

    init(
        mockData: Data = Data(),
        mockResponse: URLResponse? = nil,
        mockError: Error? = nil
    ) {
        self.mockData = mockData
        self.mockResponse = mockResponse ?? HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        self.mockError = mockError
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        calls.append(Call(request: request))

        if let error = mockError {
            throw error
        }

        return (mockData, mockResponse)
    }
}
