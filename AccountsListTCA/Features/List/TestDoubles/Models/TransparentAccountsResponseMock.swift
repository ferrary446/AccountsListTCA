//
//  TransparentAccountsResponseMock.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

import Foundation

extension TransparentAccountsResponse {
    static func makeMock(
        pageNumber: Int = 0,
        pageCount: Int = 0,
        pageSize: Int = 0,
        recordCount: Int = 0,
        nextPage: Int = 0,
        accounts: [TransparentAccountDTO] = []
    ) -> Self {
        TransparentAccountsResponse(
            pageNumber: pageNumber,
            pageCount: pageCount,
            pageSize: pageSize,
            recordCount: recordCount,
            nextPage: nextPage,
            accounts: accounts
        )
    }
}
