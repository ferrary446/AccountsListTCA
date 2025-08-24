//
//  GetTransparentAccountsUseCase.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture

protocol GetTransparentAccountsUseCase {
    func callAsFunction() async throws -> [TransparentAccount]
}

struct GetTransparentAccountsLiveUseCase: GetTransparentAccountsUseCase {
    @Dependency(\.accountsListRepository) var repository

    func callAsFunction() async throws -> [TransparentAccount] {
        try await repository.getTransparentAccounts()
    }
}
