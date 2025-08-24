//
//  AccountsListRepository.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

protocol AccountsListRepository {
    func getTransparentAccounts() async throws -> [TransparentAccount]
}
