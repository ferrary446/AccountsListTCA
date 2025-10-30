//
//  GetTransparentAccountsUseCaseSpy.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

import ComposableArchitecture

final class GetTransparentAccountsUseCaseSpy: GetTransparentAccountsUseCase, @unchecked Sendable {
    private(set) var calls: Int = 0

    private let convertReturn: [TransparentAccount]
    private let errorToThrow: (any Error)?

    init(convertReturn: [TransparentAccount] = [], errorToThrow: (any Error)? = nil) {
        self.convertReturn = convertReturn
        self.errorToThrow = errorToThrow
    }

    func callAsFunction() async throws -> [TransparentAccount] {
        calls += 1

        if let errorToThrow {
            throw errorToThrow
        }

        return convertReturn
    }
}
