//
//  AccountsListFeature.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture

@Reducer
struct AccountsListFeature {
    enum Action: Equatable {
        case initialization
        case retry
        case setContent(accounts: [TransparentAccount])
        case setError
    }

    @ObservableState
    enum State: Equatable {
        case loading
        case content(accounts: [TransparentAccount])
        case error
    }

    @Dependency(\.networkingErrorConverter) private var errorConverter
    @Dependency(\.getTransparentAccountsUseCase) private var getTransparentAccountsUseCase

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialization, .retry:
                state = .loading
                return .run(
                    operation: { send in
                        let accounts = try await getTransparentAccountsUseCase()
                        await send(.setContent(accounts: accounts))
                    },
                    catch: { error, send in
                        let error = errorConverter.convert(error: error)
                        await send(.setError)
                    }
                )
            case let .setContent(accounts):
                state = .content(accounts: accounts)
                return .none
            case .setError:
                state = .error
                return .none
            }
        }
    }
}
