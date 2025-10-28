//
//  TransparentAccount.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import Foundation

struct TransparentAccount: Equatable, Identifiable {
    let id: UUID
    let bankCode: String
    let number: String

    init(
        id: UUID = UUID(),
        bankCode: String,
        number: String
    ) {
        self.id = id
        self.bankCode = bankCode
        self.number = number
    }
}
