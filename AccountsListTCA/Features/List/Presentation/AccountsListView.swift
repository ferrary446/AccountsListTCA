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
                switch store.state {
                case .loading:
                    ProgressView()
                case .content:
                    EmptyView()
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
