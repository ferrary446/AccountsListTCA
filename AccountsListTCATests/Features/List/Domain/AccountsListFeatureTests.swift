//
//  AccountsListFeatureTests.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 30.10.2025.
//

@testable import AccountsListTCA
import ComposableArchitecture
import Testing
import Foundation

@MainActor
@Suite("AccountsListFeatureTests")
struct AccountsListFeatureTests {
    @Test("Initialization triggers loading and sets content state")
    func test_givenInitialState_whenInitialization_thenSetsContentState() async {
        let mockAccounts: [TransparentAccount] = [
            .makeMock(bankCode: "0000", number: "000000"),
            .makeMock(bankCode: "1111", number: "111111")
        ]
        let getTransparentAccountsUseCase = GetTransparentAccountsUseCaseSpy(
            convertReturn: mockAccounts
        )
        let sut = makeSUT(
            getTransparentAccountsUseCase: getTransparentAccountsUseCase
        )

        await sut.send(.initialization)

        await sut.receive(.setContent(accounts: mockAccounts)) {
            $0.contentState = .content(accounts: mockAccounts)
        }
    }

    @Test("Retry triggers loading and sets content state")
    func test_givenErrorState_whenRetry_thenSetsContentState() async {
        let mockAccounts: [TransparentAccount] = [
            .makeMock(bankCode: "0000", number: "000000"),
            .makeMock(bankCode: "1111", number: "111111")
        ]
        let getTransparentAccountsUseCase = GetTransparentAccountsUseCaseSpy(
            convertReturn: mockAccounts
        )
        let sut = makeSUT(
            initialContentState: .error(error: .unknown),
            getTransparentAccountsUseCase: getTransparentAccountsUseCase
        )

        await sut.send(.retry)

        await sut.receive(.setContent(accounts: mockAccounts)) {
            $0.contentState = .content(accounts: mockAccounts)
        }
    }

    @Test("SetContent updates content state with accounts")
    func test_givenLoadingState_whenSetContent_thenUpdatesContentState() async {
        let mockAccounts: [TransparentAccount] = [
            .makeMock(bankCode: "0000", number: "000000"),
            .makeMock(bankCode: "1111", number: "111111")
        ]
        let sut = makeSUT()

        await sut.send(.setContent(accounts: mockAccounts)) {
            $0.contentState = .content(accounts: mockAccounts)
        }
    }

    @Test("SetError updates content state with error")
    func test_givenLoadingState_whenSetError_thenUpdatesContentState() async {
        let networkingError = NetworkingError.badURL
        let sut = makeSUT()

        await sut.send(.setError(error: networkingError)) {
            $0.contentState = .error(error: networkingError)
        }
    }

    @Test("OpenAccountDetail appends account to stack state")
    func test_givenContentState_whenOpenAccountDetail_thenAppendsToStackState() async {
        let mockAccount: TransparentAccount = .makeMock(bankCode: "1234", number: "567890")
        let sut = makeSUT()

        await sut.send(.openAccountDetail(mockAccount)) {
            $0.accountDetailStackState.append(.content(account: mockAccount))
        }

        let stackState = sut.state.accountDetailStackState
        #expect(stackState.count == 1)
        if case let .content(account) = stackState.first {
            #expect(account == mockAccount)
        } else {
            Issue.record("Expected content state in stack")
        }
    }

    @Test("Multiple OpenAccountDetail actions append to stack")
    func test_givenContentState_whenMultipleOpenAccountDetail_thenAppendsAllToStackState() async {
        let account1: TransparentAccount = .makeMock(bankCode: "1111", number: "111111")
        let account2: TransparentAccount = .makeMock(bankCode: "2222", number: "222222")
        let account3: TransparentAccount = .makeMock(bankCode: "3333", number: "333333")
        let sut = makeSUT()

        await sut.send(.openAccountDetail(account1)) {
            $0.accountDetailStackState.append(.content(account: account1))
        }
        await sut.send(.openAccountDetail(account2)) {
            $0.accountDetailStackState.append(.content(account: account2))
        }
        await sut.send(.openAccountDetail(account3)) {
            $0.accountDetailStackState.append(.content(account: account3))
        }

        let stackState = sut.state.accountDetailStackState
        #expect(stackState.count == 3)
    }

    @Test("Path action does not modify state")
    func test_givenAnyState_whenPathAction_thenNoStateChange() async {
        let mockAccount: TransparentAccount = .makeMock()
        let sut = makeSUT()

        // First add an element to the stack so the path action has something to operate on
        await sut.send(.openAccountDetail(mockAccount)) {
            $0.accountDetailStackState.append(.content(account: mockAccount))
        }

        let stateBeforePathAction = sut.state

        // Now send a path action that operates on the existing element
        await sut.send(.path(.element(id: sut.state.accountDetailStackState.ids.first!, action: .initialization(account: mockAccount))))

        // The main state should remain unchanged, only the nested state might change
        #expect(sut.state.contentState == stateBeforePathAction.contentState)
    }

    @Test("State equality works correctly")
    func test_givenSameStates_whenComparingStates_thenAreEqual() {
        let mockAccounts: [TransparentAccount] = [
            .makeMock(bankCode: "1234", number: "567890")
        ]
        let state1 = AccountsListFeature.State(
            contentState: .content(accounts: mockAccounts)
        )
        let state2 = AccountsListFeature.State(
            contentState: .content(accounts: mockAccounts)
        )
        let state3 = AccountsListFeature.State(
            contentState: .loading
        )

        #expect(state1 == state2)
        #expect(state1 != state3)
        #expect(state2 != state3)
    }

    @Test("Action equality works correctly")
    func test_givenSameActions_whenComparingActions_thenAreEqual() {
        let mockAccount: TransparentAccount = .makeMock(bankCode: "1234", number: "567890")
        let action1 = AccountsListFeature.Action.openAccountDetail(mockAccount)
        let action2 = AccountsListFeature.Action.openAccountDetail(mockAccount)
        let action3 = AccountsListFeature.Action.initialization

        #expect(action1 == action2)
        #expect(action1 != action3)
        #expect(action2 != action3)
    }

    @Test("ContentState equality works correctly")
    func test_givenSameContentStates_whenComparingContentStates_thenAreEqual() {
        let mockAccounts: [TransparentAccount] = [
            .makeMock(bankCode: "1234", number: "567890")
        ]
        let otherAccounts: [TransparentAccount] = [
            .makeMock(bankCode: "9876", number: "543210")
        ]

        let contentState1 = AccountsListFeature.State.ContentState.content(accounts: mockAccounts)
        let contentState2 = AccountsListFeature.State.ContentState.content(accounts: mockAccounts)
        let contentState3 = AccountsListFeature.State.ContentState.content(accounts: otherAccounts)
        let loadingState = AccountsListFeature.State.ContentState.loading

        #expect(contentState1 == contentState2)
        #expect(contentState1 != contentState3)
        #expect(contentState1 != loadingState)
    }

    @Test("Empty accounts list is handled correctly")
    func test_givenEmptyAccountsList_whenSetContent_thenStoresEmptyList() async {
        let emptyAccounts: [TransparentAccount] = []
        let sut = makeSUT()

        await sut.send(.setContent(accounts: emptyAccounts)) {
            $0.contentState = .content(accounts: emptyAccounts)
        }

        if case let .content(accounts) = sut.state.contentState {
            #expect(accounts.isEmpty)
        } else {
            Issue.record("Expected content state with empty accounts")
        }
    }

    @Test("Large accounts list is handled efficiently")
    func test_givenLargeAccountsList_whenSetContent_thenHandlesEfficiently() async {
        let largeAccountsList = (0..<1000).map { i in
            TransparentAccount.makeMock(bankCode: "BANK\(i)", number: "NUM\(i)")
        }
        let sut = makeSUT()

        let startTime = CFAbsoluteTimeGetCurrent()
        await sut.send(.setContent(accounts: largeAccountsList)) {
            $0.contentState = .content(accounts: largeAccountsList)
        }
        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = endTime - startTime

        #expect(executionTime < 1.0, "Setting large accounts list should be performant")

        if case let .content(accounts) = sut.state.contentState {
            #expect(accounts.count == 1000)
        } else {
            Issue.record("Expected content state with large accounts list")
        }
    }

    @Test("Different error types are handled correctly")
    func test_givenDifferentErrors_whenSetError_thenStoresCorrectError() async {
        let errors: [NetworkingError] = [
            .badURL,
            .failToDecodeData,
            .unknown
        ]

        for error in errors {
            let sut = makeSUT()
            await sut.send(.setError(error: error)) {
                $0.contentState = .error(error: error)
            }

            if case let .error(storedError) = sut.state.contentState {
                #expect(storedError == error)
            } else {
                Issue.record("Expected error state with \(error)")
            }
        }
    }

    @Test("Initialization with error triggers error state")
    func test_givenFailingUseCase_whenInitialization_thenSetsErrorState() async {
        let expectedError = NetworkingError.badURL
        let errorConverter = NetworkingErrorConverterSpy(convertReturn: expectedError)
        let failingUseCase = GetTransparentAccountsUseCaseSpy(errorToThrow: expectedError)
        let sut = makeSUT(
            errorConverter: errorConverter,
            getTransparentAccountsUseCase: failingUseCase
        )

        await sut.send(.initialization)

        await sut.receive(.setError(error: expectedError)) {
            $0.contentState = .error(error: expectedError)
        }
    }
}

private extension AccountsListFeatureTests {
    func makeSUT(
        initialContentState: AccountsListFeature.State.ContentState = .loading,
        errorConverter: NetworkingErrorConverter = NetworkingErrorConverterSpy(),
        getTransparentAccountsUseCase: GetTransparentAccountsUseCase = GetTransparentAccountsUseCaseSpy()
    ) -> TestStore<AccountsListFeature.State, AccountsListFeature.Action> {
        TestStore(
            initialState: AccountsListFeature.State(
                contentState: initialContentState
            ),
            reducer: {
                AccountsListFeature()
            },
            withDependencies: {
                $0.networkingErrorConverter = errorConverter
                $0.getTransparentAccountsUseCase = getTransparentAccountsUseCase
            }
        )
    }
}
