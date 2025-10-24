//
//  AccountsListRemoteRepository.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture

struct AccountsListRemoteRepository: AccountsListRepository {
    @Dependency(\.transparentAccountConverter) private var converter
    @Dependency(\.networkingService) private var service

    func getTransparentAccounts() async throws -> [TransparentAccount] {
        let response: TransparentAccountsResponse = try await service.run(
            endpoint: TransparentAccountsEndpoint.getTransparentAccounts
        )

        return response.accounts.map {
            converter.convert(dto: $0)
        }
    }
}
