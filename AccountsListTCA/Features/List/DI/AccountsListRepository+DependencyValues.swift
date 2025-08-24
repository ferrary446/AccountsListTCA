//
//  AccountsListRepository+DependencyValues.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture

extension DependencyValues {
    enum AccountsListRepositoryDependencyKey: DependencyKey {
        static var liveValue: any AccountsListRepository {
            AccountsListRemoteRepository()
        }
    }

    var accountsListRepository: AccountsListRepository {
        get { self[AccountsListRepositoryDependencyKey.self] }
        set { self[AccountsListRepositoryDependencyKey.self] = newValue }
    }
}
