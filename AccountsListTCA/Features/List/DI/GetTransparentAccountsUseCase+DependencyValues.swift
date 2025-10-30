//
//  GetTransparentAccountsUseCase+DependencyValues.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture

extension DependencyValues {
    enum GetTransparentAccountsUseCaseDependencyKey: DependencyKey {
        static var liveValue: any GetTransparentAccountsUseCase {
            GetTransparentAccountsLiveUseCase()
        }

        static var testValue: any GetTransparentAccountsUseCase {
            GetTransparentAccountsUseCaseSpy()
        }
    }

    var getTransparentAccountsUseCase: GetTransparentAccountsUseCase {
        get { self[GetTransparentAccountsUseCaseDependencyKey.self] }
        set { self[GetTransparentAccountsUseCaseDependencyKey.self] = newValue }
    }
}
