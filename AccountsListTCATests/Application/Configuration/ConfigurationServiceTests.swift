//
//  ConfigurationServiceTests.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import Foundation
import Testing

@Suite("ConfigurationServiceTests")
struct ConfigurationServiceTests {
    @Test("APIKey received")
    func test_whenAPIKeyReceived_thenValueMatched() throws {
        let sut = makeSUT()

        let apiKey = try sut.getInformationPlistValue(key: .apiKey)

        #expect(!apiKey.isEmpty)
    }

    @Test("APIKey not received")
    func test_whenAPIKeyNotReceived_thenValueMatched() throws {
        let sut = makeSUT(bundle: BundleMock())

        #expect(throws: ConfigurationService.ConfigurationError.self) {
            let apiKey = try sut.getInformationPlistValue(key: .apiKey)
            #expect(apiKey.isEmpty)
        }
    }

    @Test("Host received")
    func test_whenHostReceived_thenValueMatched() throws {
        let sut = makeSUT()

        let host = try sut.getInformationPlistValue(key: .host)

        #expect(!host.isEmpty)
    }

    @Test("Host not received")
    func test_whenHostNotReceived_thenValueMatched() throws {
        let sut = makeSUT(bundle: BundleMock())

        #expect(throws: ConfigurationService.ConfigurationError.self) {
            let host = try sut.getInformationPlistValue(key: .host)
            #expect(host.isEmpty)
        }
    }

    @Test("Info dictionary return nil")
    func test_givenInfoDictionaryReturnNil_whenHostNotReceived_thenValueMatched() throws {
        let sut = makeSUT(bundle: BundleMock(infoDictionaryReturn: nil))

        #expect(throws: ConfigurationService.ConfigurationError.self) {
            let host = try sut.getInformationPlistValue(key: .host)
            #expect(host.isEmpty)
        }
    }
}

private extension ConfigurationServiceTests {
    func makeSUT(bundle: Bundle = .main) -> ConfigurationServiceful {
        ConfigurationService(bundle: bundle)
    }
}
