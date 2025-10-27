//
//  AccountDetailFeature.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 27.10.2025.
//

import ComposableArchitecture

@Reducer
struct AccountDetailFeature {
    enum Action: Equatable {
        case initialization(account: TransparentAccount)
    }

    @ObservableState
    enum State: Equatable {
        case content(account: TransparentAccount)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .initialization(account):
                state = .content(account: account)
                return .none
            }
        }
    }
}
