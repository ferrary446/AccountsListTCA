//
//  TransparentAccountDTO.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import Foundation

struct TransparentAccountDTO: Decodable {
    let accountNumber: String
    let bankCode: String
    let transparencyFrom: Date
    let transparencyTo: Date
    let publicationTo: Date
    let actualizationDate: Date
    let balance: Double
    let currency: String
    let name: String
    let description: String
    let note: String
    let iban: String
    let statements: [String]
}
