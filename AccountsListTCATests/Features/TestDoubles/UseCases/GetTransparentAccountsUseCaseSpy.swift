//
//  GetTransparentAccountsUseCaseSpy.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import ComposableArchitecture

final class GetTransparentAccountsUseCaseSpy: GetTransparentAccountsUseCase, @unchecked Sendable {
    private(set) var calls: Int = 0

    private let convertReturn: [TransparentAccount]

    init(convertReturn: [TransparentAccount] = []) {
        self.convertReturn = convertReturn
    }

    func callAsFunction() async throws -> [TransparentAccount] {
        calls += 1

        return convertReturn
    }
}
