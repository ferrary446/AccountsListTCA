//
//  NetworkingErrorView.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 27.10.2025.
//

import SwiftUI

struct NetworkingErrorView: View {
    let error: NetworkingError
    let onRetry: @MainActor () -> Void

    var body: some View {
        switch error {
        case let .api(error):
            VStack(spacing: 16) {
                Text("Status code: \(error.status)")

                ForEach(error.errors, id: \.error) {
                    Text($0.error)
                }

                makeRetryButton()
            }
        case .badURL:
            VStack(spacing: 16) {
                Text("Bad URL")
                makeRetryButton()
            }
        case .failToDecodeData:
            VStack(spacing: 16) {
                Text("Fail to decode data")
                makeRetryButton()
            }
        case .unknown:
            VStack(spacing: 16) {
                Text("Unknown error")
                makeRetryButton()
            }
        }
    }

    private func makeRetryButton() -> some View {
        Button("Retry", action: onRetry)
    }
}
