//
//  NetworkingErrorConverterTests.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import Testing

@Suite("NetworkingErrorConverterTests")
struct NetworkingErrorConverterTests {
    @Test("ExpectedErrorIsBadURL")
    func test_givenBadURLError_whenConvert_thenExpectedErrorMatched() {
        let expectedError: NetworkingError = .badURL
        let sut = makeSUT()

        let networkingError = sut.convert(error: expectedError)

        #expect(networkingError == expectedError)
    }

    @Test("ExpectedErrorIsFailToDecodeData")
    func test_givenFailToDecodeDataError_whenConvert_thenExpectedErrorMatched() {
        let expectedError: NetworkingError = .failToDecodeData
        let sut = makeSUT()

        let networkingError = sut.convert(error: expectedError)

        #expect(networkingError == expectedError)
    }

    @Test("ExpectedAPIError")
    func test_givenAPIError_whenConvert_thenExpectedErrorMatched() {
        let expectedError: NetworkingError = .api(error: .makeMock())
        let sut = makeSUT()

        let networkingError = sut.convert(error: expectedError)

        #expect(networkingError == expectedError)
    }

    @Test("ExpectedUnknownError")
    func test_givenUnknownError_whenConvert_thenExpectedErrorMatched() {
        let error: MockError = .error
        let sut = makeSUT()

        let networkingError = sut.convert(error: error)

        #expect(networkingError == .unknown)
    }
}

private extension NetworkingErrorConverterTests {
    func makeSUT() -> NetworkingErrorConverter {
        NetworkingErrorConverterImp()
    }
}
