//
//  NetworkingServiceTests.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import Foundation
import Testing

@Suite("NetworkingServiceTests")
struct NetworkingServiceTests {
    @Test("GetEndpointTest - Success Response")
    func test_givenGetEndpoint_whenRun_thenResponseMatched() async throws {
        let service = ConfigurationServiceSpy(
            convertReturn: [
                .apiKey: "apiKey",
                .host: "host"
            ]
        )
        let converter = HTTPHeadersConverterSpy(convertReturn: [
            "Accept": "application/json",
            "WEB-API-key": "apiKey"
        ])
        let mockResponseData = """
        {}
        """.data(using: .utf8)!
        let mockURLSession = URLSessionSpy(
            mockData: mockResponseData,
            mockResponse: HTTPURLResponse(
                url: URL(string: "https://host/path")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        let getEndpoint: MockEndpoint = .getRequestMock(
            body: nil,
            headers: ["Custom-Header": "Custom-Value"],
            query: ["query": "value"]
        )
        let sut = makeSUT(
            converter: converter,
            service: service,
            urlSession: mockURLSession
        )

        let _: MockResponse = try await sut.run(endpoint: getEndpoint)

        #expect(converter.calls.count == 1)
        #expect(service.calls.count == 2)
        #expect(converter.calls.first?.apiKey == "apiKey")
        #expect(converter.calls.first?.headers == ["Custom-Header": "Custom-Value"])
        #expect(mockURLSession.calls.count == 1)
        let capturedRequest = mockURLSession.calls.first?.request
        #expect(capturedRequest?.url?.absoluteString == "https://host/path?query=value")
        #expect(capturedRequest?.httpMethod == "GET")
        #expect(capturedRequest?.httpBody == nil)
        #expect(capturedRequest?.allHTTPHeaderFields?["Accept"] == "application/json")
        #expect(capturedRequest?.allHTTPHeaderFields?["WEB-API-key"] == "apiKey")
    }

    @Test("PostEndpointTest - With Body")
    func test_givenPostEndpointWithBody_whenRun_thenRequestConfiguredCorrectly() async throws {
        let service = ConfigurationServiceSpy(convertReturn: [.host: "host"])
        let converter = HTTPHeadersConverterSpy(convertReturn: [
            "Accept": "application/json",
            "WEB-API-key": "apiKey",
            "Content-Type": "application/json"
        ])
        let requestBody = """
        {"test": "data"}
        """.data(using: .utf8)!

        let mockResponseData = """
        {}
        """.data(using: .utf8)!
        let mockURLSession = URLSessionSpy(
            mockData: mockResponseData,
            mockResponse: HTTPURLResponse(
                url: URL(string: "https://host/path")!,
                statusCode: 201,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        let postEndpoint: MockEndpoint = .postRequestMock(
            body: requestBody,
            headers: ["Content-Type": "application/json"],
            query: [:]
        )
        let sut = makeSUT(
            converter: converter,
            service: service,
            urlSession: mockURLSession
        )

        let _: MockResponse = try await sut.run(endpoint: postEndpoint)

        #expect(mockURLSession.calls.count == 1)
        let capturedRequest = mockURLSession.calls.first?.request
        #expect(capturedRequest?.url?.absoluteString == "https://host/path")
        #expect(capturedRequest?.httpMethod == "POST")
        #expect(capturedRequest?.httpBody == requestBody)
    }

    @Test("NetworkError - Server Error Response")
    func test_givenServerError_whenRun_thenThrowsNetworkingError() async throws {
        let service = ConfigurationServiceSpy(convertReturn: [.host: "host"])
        let converter = HTTPHeadersConverterSpy()
        let mockURLSession = URLSessionSpy(
            mockData: Data(),
            mockResponse: HTTPURLResponse(
                url: URL(string: "https://host/path")!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        let getEndpoint: MockEndpoint = .getRequestMock(
            body: nil,
            headers: [:],
            query: [:]
        )
        let sut = makeSUT(
            converter: converter,
            service: service,
            urlSession: mockURLSession
        )

        await #expect(throws: NetworkingError.self) {
            let _: MockResponse = try await sut.run(endpoint: getEndpoint)
        }
    }

    @Test("BadURL Error")
    func test_givenInvalidHost_whenRun_thenThrowsBadURLError() async throws {
        let service = ConfigurationServiceSpy(convertReturn: [.host: "https://invalid host with spaces"])
        let converter = HTTPHeadersConverterSpy()
        let mockURLSession = URLSessionSpy()
        let endpoint: MockEndpoint = .getRequestMock(
            body: nil,
            headers: [:],
            query: [:]
        )
        let sut = makeSUT(
            converter: converter,
            service: service,
            urlSession: mockURLSession
        )

        await #expect(throws: NetworkingError.badURL) {
            let _: MockResponse = try await sut.run(endpoint: endpoint)
        }

        #expect(mockURLSession.calls.isEmpty)
    }

    @Test("JSON Decode Error - Fail to decode data error")
    func test_givenInvalidJSONResponse_whenRun_thenThrowsDecodeError() async throws {
        let invalidJSONData = "{ invalid json }".data(using: .utf8)!
        let service = ConfigurationServiceSpy(convertReturn: [.host: "host"])
        let converter = HTTPHeadersConverterSpy()
        let mockURLSession = URLSessionSpy(
            mockData: invalidJSONData,
            mockResponse: HTTPURLResponse(
                url: URL(string: "https://host/path")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        let endpoint: MockEndpoint = .getRequestMock(
            body: nil,
            headers: [:],
            query: [:]
        )
        let sut = makeSUT(
            converter: converter,
            service: service,
            urlSession: mockURLSession
        )

        await #expect(throws: NetworkingError.failToDecodeData) {
            let _: MockResponse = try await sut.run(endpoint: endpoint)
        }
    }

    @Test("Non-HTTPURLResponse Error - Unknown Error")
    func test_givenNonHTTPResponse_whenRun_thenThrowsUnknownError() async throws {
        let service = ConfigurationServiceSpy(convertReturn: [.host: "host"])
        let converter = HTTPHeadersConverterSpy()
        let nonHTTPResponse = URLResponse(
            url: URL(string: "https://host/path")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        let mockURLSession = URLSessionSpy(
            mockData: Data(),
            mockResponse: nonHTTPResponse
        )
        let endpoint: MockEndpoint = .getRequestMock(
            body: nil,
            headers: [:],
            query: [:]
        )
        let sut = makeSUT(
            converter: converter,
            service: service,
            urlSession: mockURLSession
        )

        await #expect(throws: NetworkingError.unknown) {
            let _: MockResponse = try await sut.run(endpoint: endpoint)
        }
    }

    @Test("Server Error with Invalid Error Response - Unknown Error")
    func test_givenServerErrorWithInvalidErrorResponse_whenRun_thenThrowsUnknownError() async throws {
        let invalidErrorData = "{ invalid error response }".data(using: .utf8)!
        let service = ConfigurationServiceSpy(convertReturn: [.host: "host"])
        let converter = HTTPHeadersConverterSpy()
        let mockURLSession = URLSessionSpy(
            mockData: invalidErrorData,
            mockResponse: HTTPURLResponse(
                url: URL(string: "https://host/path")!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        let endpoint: MockEndpoint = .getRequestMock(
            body: nil,
            headers: [:],
            query: [:]
        )
        let sut = makeSUT(
            converter: converter,
            service: service,
            urlSession: mockURLSession
        )

        await #expect(throws: NetworkingError.unknown) {
            let _: MockResponse = try await sut.run(endpoint: endpoint)
        }
    }

    @Test("Server Error with Valid Error Response - API Error")
    func test_givenServerErrorWithValidErrorResponse_whenRun_thenThrowsAPIError() async throws {
        let errorResponse = NetworkingErrorResponse(
            status: 400,
            errors: [
                NetworkingErrorResponse.Error(
                    error: "INVALID_REQUEST",
                    parameters: nil,
                    scope: nil
                )
            ],
            transactionID: "12345"
        )
        let errorData = try JSONEncoder().encode(errorResponse)
        let service = ConfigurationServiceSpy(convertReturn: [.host: "host"])
        let converter = HTTPHeadersConverterSpy()
        let mockURLSession = URLSessionSpy(
            mockData: errorData,
            mockResponse: HTTPURLResponse(
                url: URL(string: "https://host/path")!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        let endpoint: MockEndpoint = .getRequestMock(
            body: nil,
            headers: [:],
            query: [:]
        )
        let sut = makeSUT(
            converter: converter,
            service: service,
            urlSession: mockURLSession
        )

        await #expect(throws: NetworkingError.api(error: errorResponse)) {
            let _: MockResponse = try await sut.run(endpoint: endpoint)
        }
    }
}

private extension NetworkingServiceTests {
    func makeSUT(
        converter: HTTPHeadersConverter = HTTPHeadersConverterSpy(),
        service: ConfigurationServiceful = ConfigurationServiceSpy(convertReturn: [.host: "host"]),
        urlSession: URLSessionProtocol = URLSessionSpy()
    ) -> NetworkingServiceful {
        NetworkingService(
            converter: converter,
            service: service,
            urlSession: urlSession
        )
    }
}
