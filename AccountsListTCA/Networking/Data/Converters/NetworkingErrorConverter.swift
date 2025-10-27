//
//  NetworkingErrorConverter.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

protocol NetworkingErrorConverter {
    func convert(error: any Error) -> NetworkingError
}

struct NetworkingErrorConverterImp: NetworkingErrorConverter {
    func convert(error: any Error) -> NetworkingError {
        guard let error = error as? NetworkingError else {
            return .unknown
        }

        return error
    }
}
