//
//  NetworkingErrorConverterSpy.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

import ComposableArchitecture

final class NetworkingErrorConverterSpy: NetworkingErrorConverter, @unchecked Sendable {
    struct Call {
        let error: any Error
    }

    private(set) var calls = [Call]()

    private let convertReturn: NetworkingError

    init(convertReturn: NetworkingError = .unknown) {
        self.convertReturn = convertReturn
    }

    func convert(error: any Error) -> NetworkingError {
        calls.append(Call(error: error))

        return convertReturn
    }
}
