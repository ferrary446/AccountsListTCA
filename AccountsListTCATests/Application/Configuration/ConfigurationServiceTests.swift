//
//  ConfigurationServiceTests.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//
@testable import AccountsListTCA
import Testing

@Suite("ConfigurationServiceTests")
struct ConfigurationServiceTests {
    @Test("APIKey received")
    func test_givenEmptyExpectedHeaders_whenAPIKeyReceived_thenValueMatched() {
        let expectedAPIKey = "key"
        let sut = makeSUT()

        let apiKey = sut.getInformationPlistValue(key: .apiKey)

        #expect(apiKey == expectedAPIKey)
    }
}

private extension ConfigurationServiceTests {
    func makeSUT() -> ConfigurationServiceful {
        ConfigurationService()
    }
}
