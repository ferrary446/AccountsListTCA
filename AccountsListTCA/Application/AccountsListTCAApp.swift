//
//  AccountsListTCAApp.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 23.08.2025.
//

import ComposableArchitecture
import SwiftUI

@main
struct AccountsListTCAApp: App {
    var body: some Scene {
        WindowGroup {
            AccountsListFlow(
                store: Store(
                    initialState: AccountsListFeature.State(),
                    reducer: {
                        AccountsListFeature()
                    }
                )
            )
        }
    }
}
