//
//  AccountsListFeature.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture

@Reducer
struct AccountsListFeature {
    enum Action {
        case initialization
        case retry
        case setContent
        case setError
    }

    @ObservableState
    enum State: Equatable {
        case loading
        case content
        case error
    }

    @Dependency(\.networkingErrorConverter) var errorConverter
    @Dependency(\.getTransparentAccountsUseCase) var getTransparentAccountsUseCase

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialization, .retry:
                return .run(
                    operation: { send in
                        let accounts = try await getTransparentAccountsUseCase()
                        await send(.setContent)
                    },
                    catch: { error, send in
                        let error = errorConverter.convert(error: error)
                        await send(.setError)
                    }
                )
            case .setContent:
                state = .content
                return .none
            case .setError:
                state = .error
                return .none
            }
        }
    }
}
