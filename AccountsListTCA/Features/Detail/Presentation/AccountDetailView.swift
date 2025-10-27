//
//  AccountDetailView.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 27.10.2025.
//

import ComposableArchitecture
import SwiftUI

struct AccountDetailView: View {
    let store: StoreOf<AccountDetailFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { store in
            switch store.state {
            case let .content(account):
                Text([account.number, account.bankCode].joined(separator: "/"))
            }
        }
    }
}
