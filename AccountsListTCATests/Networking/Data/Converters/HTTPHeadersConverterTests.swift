//
//  HTTPHeadersConverterTests.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import Testing

@Suite("HTTPHeadersConverterTests")
struct HTTPHeadersConverterTests {
    @Test("EmptyExpectedHeaders")
    func test_givenEmptyExpectedHeaders_whenConvert_thenHeadersMatched() {
        let expectedAPIKey = "key"
        let expectedHeaders = [String: String]()
        let sut = makeSUT()

        let headers = sut.convert(
            apiKey: expectedAPIKey,
            headers: expectedHeaders
        )

        #expect(headers.count == 2)
        #expect(headers["Accept"] == "application/json")
        #expect(headers["WEB-API-key"] == expectedAPIKey)
    }

    @Test("NonEmptyExpectedHeaders")
    func test_givenNonEmptyExpectedHeaders_whenConvert_thenHeadersMatched() {
        let expectedAPIKey = "key"
        let expectedHeaders = [
            "Header1": "Value1",
            "Header2": "Value2"
        ]
        let sut = makeSUT()

        let headers = sut.convert(
            apiKey: expectedAPIKey,
            headers: expectedHeaders
        )

        #expect(headers.count == 4)
        #expect(headers["Accept"] == "application/json")
        #expect(headers["WEB-API-key"] == expectedAPIKey)

        for (key, value) in expectedHeaders {
            #expect(headers[key] == value, "Header \(key) should match expected value")
        }
    }
}

private extension HTTPHeadersConverterTests {
    func makeSUT() -> HTTPHeadersConverter {
        HTTPHeadersConverterImp()
    }
}
