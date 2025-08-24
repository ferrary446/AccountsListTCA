//
//  AccountsListRemoteRepository.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture

struct AccountsListRemoteRepository: AccountsListRepository {
    @Dependency(\.transparentAccountConverter) var converter
    @Dependency(\.networkingService) var service

    func getTransparentAccounts() async throws -> [TransparentAccount] {
        let response: TransparentAccountsResponse = try await service.run(
            endpoint: TransparentAccountsEndpoint.getTransparentAccounts
        )

        return response.accounts.map {
            converter.convert(dto: $0)
        }
    }
}
