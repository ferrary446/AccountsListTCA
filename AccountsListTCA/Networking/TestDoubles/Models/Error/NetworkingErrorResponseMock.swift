//
//  NetworkingErrorResponseMock.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

extension NetworkingErrorResponse {
    static func makeMock(
        status: Int = 500,
        errors: [NetworkingErrorResponse.Error] = [],
        transactionID: String? = nil
    ) -> Self {
        NetworkingErrorResponse(
            status: status,
            errors: errors,
            transactionID: transactionID
        )
    }
}

extension NetworkingErrorResponse.Error {
    static func makeMock(
        error: String = "error",
        parameters: [Parameter]? = nil,
        scope: String? = nil
    ) -> Self {
        NetworkingErrorResponse.Error(
            error: error,
            parameters: parameters,
            scope: scope
        )
    }
}

extension NetworkingErrorResponse.Error.Parameter {
    static func makeMock(
        amountEntered: Int = 1,
        currency: String = "currency",
        limit: Int = 1
    ) -> Self {
        NetworkingErrorResponse.Error.Parameter(
            amountEntered: amountEntered,
            currency: currency,
            limit: limit
        )
    }
}
