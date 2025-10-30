//
//  TransparentAccountConverterSpy.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

import ComposableArchitecture

final class TransparentAccountConverterSpy: TransparentAccountConverter, @unchecked Sendable {
    struct Call {
        let dto: TransparentAccountDTO
    }

    private(set) var calls = [Call]()

    private let convertReturn: TransparentAccount

    init(convertReturn: TransparentAccount = .makeMock()) {
        self.convertReturn = convertReturn
    }

    func convert(dto: TransparentAccountDTO) -> TransparentAccount {
        calls.append(Call(dto: dto))

        return convertReturn
    }
}
