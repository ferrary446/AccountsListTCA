//
//  AccountsListFlow.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 27.10.2025.
//

import ComposableArchitecture
import SwiftUI

struct AccountsListFlow: View {
    let store: StoreOf<AccountsListFeature>

    var body: some View {
        NavigationStackStore(
            store.scope(state: \.accountDetailStackState, action: \.path),
            root: {
                AccountsListView(store: store)
            },
            destination: { store in
                AccountDetailView(store: store)
            }
        )
    }
}
