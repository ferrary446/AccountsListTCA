//
//  TransparentAccountMock.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import Foundation

extension TransparentAccount {
    static func makeMock(
        id: UUID = UUID(),
        bankCode: String = "bankCode",
        number: String = "number"
    ) -> Self {
        TransparentAccount(
            id: id,
            bankCode: bankCode,
            number: number
        )
    }
}
