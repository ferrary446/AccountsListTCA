//
//  AccountDetailFeatureTests.swift
//  AccountsListTCATests
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import ComposableArchitecture
import Testing
import Foundation

 @MainActor
 @Suite("AccountDetailFeatureTests")
 struct AccountDetailFeatureTests {
    @Test("Initialization sets content state")
    func test_givenMockAccount_whenInitialization_thenSetsContentState() async {
        let initialAccount: TransparentAccount = .makeMock(bankCode: "0000", number: "000000")
        let newAccount: TransparentAccount = .makeMock(bankCode: "1111", number: "111111")
        let sut = makeSUT(account: initialAccount)

        await sut.send(.initialization(account: newAccount)) {
            $0 = .content(account: newAccount)
        }
    }

    @Test("Initialization handles different account data")
    func test_givenDifferentAccount_whenInitialization_thenUpdatesState() async {
        let initialAccount: TransparentAccount = .makeMock(bankCode: "0000", number: "000000")
        let newAccount: TransparentAccount = .makeMock(bankCode: "1111", number: "111111")
        let sut = makeSUT(account: initialAccount)

        await sut.send(.initialization(account: newAccount)) {
            $0 = .content(account: newAccount)
        }

        let finalState = sut.state
        if case let .content(account) = finalState {
            #expect(account.bankCode == "1111")
            #expect(account.number == "111111")
            #expect(account == newAccount)
        } else {
            Issue.record("Expected content state with new account")
        }
    }

    @Test("State equality works correctly")
    func test_givenSameAccounts_whenComparingStates_thenAreEqual() {
        let sampleAccount: TransparentAccount = .makeMock(bankCode: "1234", number: "567890")
        let anotherAccount: TransparentAccount = .makeMock(bankCode: "9876", number: "543210")
        let state1 = AccountDetailFeature.State.content(account: sampleAccount)
        let state2 = AccountDetailFeature.State.content(account: sampleAccount)
        let state3 = AccountDetailFeature.State.content(account: anotherAccount)

        #expect(state1 == state2)
        #expect(state1 != state3)
        #expect(state2 != state3)
    }

    @Test("Action equality works correctly")
    func test_givenSameAccounts_whenComparingActions_thenAreEqual() {
        let sampleAccount: TransparentAccount = .makeMock(bankCode: "1234", number: "567890")
        let anotherAccount: TransparentAccount = .makeMock(bankCode: "9876", number: "543210")
        let action1 = AccountDetailFeature.Action.initialization(account: sampleAccount)
        let action2 = AccountDetailFeature.Action.initialization(account: sampleAccount)
        let action3 = AccountDetailFeature.Action.initialization(account: anotherAccount)

        #expect(action1 == action2)
        #expect(action1 != action3)
        #expect(action2 != action3)
    }

    @Test("Multiple initialization actions in sequence")
    func test_givenMultipleAccounts_whenSequentialInitializations_thenUsesLastAccount() async {
        let account1: TransparentAccount = .makeMock(bankCode: "1111", number: "111111")
        let account2: TransparentAccount = .makeMock(bankCode: "2222", number: "222222")
        let account3: TransparentAccount = .makeMock(bankCode: "3333", number: "333333")
        let sut = makeSUT(account: account1)

        await sut.send(.initialization(account: account2)) {
            $0 = .content(account: account2)
        }
        await sut.send(.initialization(account: account3)) {
            $0 = .content(account: account3)
        }

        let finalState = sut.state
        if case let .content(account) = finalState {
            #expect(account == account3)
        } else {
            Issue.record("Expected content state with final account")
        }
    }

    @Test("Initialization with empty strings")
    func test_givenAccountWithEmptyStrings_whenInitialization_thenStoresEmptyValues() async {
        let sampleAccount: TransparentAccount = .makeMock(bankCode: "1234", number: "567890")
        let accountWithEmptyStrings: TransparentAccount = .makeMock(
            bankCode: "",
            number: ""
        )
        let sut = makeSUT(account: sampleAccount)

        await sut.send(.initialization(account: accountWithEmptyStrings)) {
            $0 = .content(account: accountWithEmptyStrings)
        }

        let finalState = sut.state
        if case let .content(account) = finalState {
            #expect(account.bankCode.isEmpty)
            #expect(account.number.isEmpty)
        } else {
            Issue.record("Expected content state with empty string account")
        }
    }

    @Test("Initialization with special characters")
    func test_givenAccountWithSpecialCharacters_whenInitialization_thenStoresSpecialCharacters() async {
        let sampleAccount: TransparentAccount = .makeMock(bankCode: "1234", number: "567890")
        let accountWithSpecialChars: TransparentAccount = .makeMock(
            bankCode: "ABC-123!@#",
            number: "XYZ-789$%^"
        )
        let sut = makeSUT(account: sampleAccount)

        await sut.send(.initialization(account: accountWithSpecialChars)) {
            $0 = .content(account: accountWithSpecialChars)
        }

        let finalState = sut.state
        if case let .content(account) = finalState {
            #expect(account.bankCode == "ABC-123!@#")
            #expect(account.number == "XYZ-789$%^")
        } else {
            Issue.record("Expected content state with special characters account")
        }
    }

    @Test("Initialization performance is efficient")
    func test_givenManyAccounts_whenMultipleInitializations_thenPerformsEfficiently() async {
        let sampleAccount: TransparentAccount = .makeMock(bankCode: "1234", number: "567890")
        let sut = makeSUT(account: sampleAccount)

        let startTime = CFAbsoluteTimeGetCurrent()
        for i in 0..<100 {
            let account = TransparentAccount(
                bankCode: "BANK\(i)",
                number: "NUM\(i)"
            )

            await sut.send(.initialization(account: account)) {
                $0 = .content(account: account)
            }
        }
        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = endTime - startTime

        #expect(executionTime < 1.0, "Initialization should be performant")
    }
 }

 private extension AccountDetailFeatureTests {
    func makeSUT(
        account: TransparentAccount = .makeMock()
    ) -> TestStore<AccountDetailFeature.State, AccountDetailFeature.Action> {
        TestStore(
            initialState: AccountDetailFeature.State.content(
                account: account
            ),
            reducer: {
                AccountDetailFeature()
            }
        )
    }
 }
