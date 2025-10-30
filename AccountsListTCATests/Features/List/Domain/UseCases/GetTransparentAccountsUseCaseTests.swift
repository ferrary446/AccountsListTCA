//
//  GetTransparentAccountsUseCaseTests.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 30.10.2025.
//

@testable import AccountsListTCA
import ComposableArchitecture
import Testing

@Suite("GetTransparentAccountsUseCaseTests")
struct GetTransparentAccountsUseCaseTests {
    @Test("GetTransparentAccountsUseCase - Success")
    func test_whenUseCaseCalled_thenAccountsReceived() async throws {
        let repository = AccountsListRepositorySpy(convertReturn: [.makeMock(), .makeMock(), .makeMock()])
        let sut = makeSUT(repository: repository)

        let accounts = try await sut()

        #expect(accounts.count == 3)
    }

    @Test("GetTransparentAccountsUseCase - Failed")
    func test_whenUseCaseCalled_thenErrorReceived() async throws {
        let repository = AccountsListRepositorySpy(
            convertReturn: [.makeMock(), .makeMock(), .makeMock()],
            errorToThrow: MockError.error
        )
        let sut = makeSUT(repository: repository)

        await #expect(throws: MockError.self) {
            try await sut()
        }
    }
}

private extension GetTransparentAccountsUseCaseTests {
    func makeSUT(
        repository: AccountsListRepository = AccountsListRepositorySpy()
    ) -> GetTransparentAccountsUseCase {
        withDependencies {
            $0.accountsListRepository = repository
        } operation: {
            GetTransparentAccountsLiveUseCase()
        }
    }
}
