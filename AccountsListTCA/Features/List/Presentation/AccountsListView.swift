//
//  AccountsListView.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture
import SwiftUI

struct AccountsListView: View {
    let store: StoreOf<AccountsListFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { store in
            Group {
                switch store.state.contentState {
                case .loading:
                    ProgressView()
                case let .content(accounts):
                    List {
                        ForEach(accounts) { account in
                            NavigationLink(
                                state: AccountDetailFeature.State.content(account: account),
                                label: {
                                    Text([account.number, account.bankCode].joined(separator: "/"))
                                }
                            )
                        }
                    }
                    .navigationTitle("Accounts")
                case .error:
                    EmptyView()
                }
            }
            .task {
                await store.send(.initialization).finish()
            }
        }
    }
}
