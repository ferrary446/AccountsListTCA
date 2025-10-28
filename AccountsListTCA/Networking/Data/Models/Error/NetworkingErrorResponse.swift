//
//  NetworkingErrorResponse.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

struct NetworkingErrorResponse: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case status
        case errors
        case transactionID = "cz-transactionId"
    }

    let status: Int
    let errors: [Error]
    let transactionID: String?
}

extension NetworkingErrorResponse {
    struct Error: Codable, Equatable {
        let error: String
        let parameters: [Parameter]?
        let scope: String?
    }
}

extension NetworkingErrorResponse.Error {
    struct Parameter: Codable, Equatable {
        enum CodingKeys: String, CodingKey {
            case amountEntered = "AMOUNT_ENTERED"
            case currency = "CURRENCY"
            case limit = "LIMIT"
        }

        let amountEntered: Int
        let currency: String
        let limit: Int
    }
}
