//
//  NetworkingError.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

enum NetworkingError: Error {
    case api(error: NetworkingErrorResponse)
    case badURL
    case failToDecodeData
    case unknown
}
