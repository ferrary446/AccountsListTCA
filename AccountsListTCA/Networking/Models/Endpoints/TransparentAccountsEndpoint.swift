//
//  TransparentAccountsEndpoint.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

enum TransparentAccountsEndpoint {
    case getTransparentAccounts
}

extension TransparentAccountsEndpoint: Endpoint {
    var method: HTTPMethod {
        switch self {
        case .getTransparentAccounts:
            .get
        }
    }

    var path: String {
        switch self {
        case .getTransparentAccounts:
            "api/csas/public/sandbox/v3/transparentAccounts"
        }
    }
}
