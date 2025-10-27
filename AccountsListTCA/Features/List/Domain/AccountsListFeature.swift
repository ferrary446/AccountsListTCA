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
        case setError(error: NetworkingError)
        case openAccountDetail(TransparentAccount)
        case path(StackAction<AccountDetailFeature.State, AccountDetailFeature.Action>)
    }

    @ObservableState
    struct State: Equatable {
        enum ContentState: Equatable {
            case loading
            case content(accounts: [TransparentAccount])
            case error(error: NetworkingError)
        }

        var contentState: ContentState = .loading
        var accountDetailStackState = StackState<AccountDetailFeature.State>()
    }

    @Dependency(\.networkingErrorConverter) private var errorConverter
    @Dependency(\.getTransparentAccountsUseCase) private var getTransparentAccountsUseCase

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialization, .retry:
                return .run(
                    operation: { send in
                        let accounts = try await getTransparentAccountsUseCase()
                        await send(.setContent(accounts: accounts))
                    },
                    catch: { error, send in
                        let error = errorConverter.convert(error: error)
                        await send(.setError(error: error))
                    }
                )
            case let .setContent(accounts):
                state.contentState = .content(accounts: accounts)
                return .none
            case let .setError(error):
                state.contentState = .error(error: error)
                return .none
            case let .openAccountDetail(account):
                state.accountDetailStackState.append(.content(account: account))
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.accountDetailStackState, action: \.path) {
            AccountDetailFeature()
        }
    }
}
