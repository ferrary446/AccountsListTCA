//
//  TransparentAccountDTOMock.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import Foundation

extension TransparentAccountDTO {
    static func makeMock(
        accountNumber: String = "accountNumber",
        bankCode: String = "bankCode",
        transparencyFrom: String = "transparencyFrom",
        transparencyTo: String = "transparencyTo",
        publicationTo: String = "publicationTo",
        actualizationDate: String = "actualizationDate",
        balance: Double = 0,
        currency: String? = nil,
        name: String = "name",
        description: String? = nil,
        note: String? = nil,
        iban: String = "iban",
        statements: [String]? = nil
    ) -> Self {
        TransparentAccountDTO(
            accountNumber: accountNumber,
            bankCode: bankCode,
            transparencyFrom: transparencyFrom,
            transparencyTo: transparencyTo,
            publicationTo: publicationTo,
            actualizationDate: actualizationDate,
            balance: balance,
            currency: currency,
            name: name,
            description: description,
            note: note,
            iban: iban,
            statements: statements
        )
    }
}
