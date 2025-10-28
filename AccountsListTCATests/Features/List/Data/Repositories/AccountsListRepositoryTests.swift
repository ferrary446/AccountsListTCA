//
//  AccountsListRepositoryTests.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import Testing
import ComposableArchitecture

@Suite("AccountsListRepositoryTests")
struct AccountsListRepositoryTests {
    @Test("GetTransparentAccounts - Success")
    func test_getTransparentAccounts_whenServiceReturnsData_thenReturnsConvertedAccounts() async throws {
        let mockAccount = TransparentAccount.makeMock()
        let converterSpy = TransparentAccountConverterSpy(convertReturn: mockAccount)
        let networkingServiceSpy = NetworkingServiceSpy(
            convertReturn: TransparentAccountsResponse.makeMock(
                pageNumber: 0,
                pageCount: 0,
                pageSize: 0,
                recordCount: 0,
                nextPage: 0,
                accounts: [.makeMock()]
            )
        )

        let sut = makeSUT(
            networkingService: networkingServiceSpy,
            converter: converterSpy
        )

        let result = try await sut.getTransparentAccounts()

        #expect(result.count == 1)
        #expect(result.first?.id == mockAccount.id)
        #expect(result.first?.number == mockAccount.number)
        #expect(networkingServiceSpy.calls.count == 1)
        #expect(converterSpy.calls.count == 1)
    }

    @Test("GetTransparentAccounts - Network Error")
    func test_getTransparentAccounts_whenNetworkError_thenThrowsError() async throws {
        let networkingServiceSpy = NetworkingServiceSpy(
            errorToThrow: NetworkingError.unknown
        )

        let sut = makeSUT(networkingService: networkingServiceSpy)

        await #expect(throws: NetworkingError.self) {
            try await sut.getTransparentAccounts()
        }
    }

    @Test("GetTransparentAccounts - Multiple Accounts")
    func test_getTransparentAccounts_whenMultipleAccountsReturned_thenConvertsAll() async throws {
        let mockAccount = TransparentAccount.makeMock()
        let converterSpy = TransparentAccountConverterSpy(convertReturn: mockAccount)
        let networkingServiceSpy = NetworkingServiceSpy(
            convertReturn: TransparentAccountsResponse.makeMock(
                pageNumber: 0,
                pageCount: 0,
                pageSize: 0,
                recordCount: 0,
                nextPage: 0,
                accounts: [.makeMock(), .makeMock(), .makeMock()]
            )
        )

        let sut = makeSUT(
            networkingService: networkingServiceSpy,
            converter: converterSpy
        )

        let result = try await sut.getTransparentAccounts()

        #expect(result.count == 3)
        #expect(converterSpy.calls.count == 3)
        #expect(networkingServiceSpy.calls.count == 1)
    }
}

private extension AccountsListRepositoryTests {
    func makeSUT(
        networkingService: NetworkingServiceful = NetworkingServiceSpy(),
        converter: TransparentAccountConverter = TransparentAccountConverterSpy()
    ) -> AccountsListRepository {
        withDependencies {
            $0.networkingService = networkingService
            $0.transparentAccountConverter = converter
        } operation: {
            AccountsListRemoteRepository()
        }
    }
}
