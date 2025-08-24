//
//  TransparentAccountsResponse.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

struct TransparentAccountsResponse: Decodable {
    let pageNumber: Int
    let pageCount: Int
    let pageSize: Int
    let recordCount: Int
    let nextPage: Int
    let accounts: [TransparentAccountDTO]
}
