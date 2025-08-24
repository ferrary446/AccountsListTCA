//
//  TransparentAccountConverter.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

protocol TransparentAccountConverter {
    func convert(dto: TransparentAccountDTO) -> TransparentAccount
}

struct TransparentAccountConverterImp: TransparentAccountConverter {
    func convert(dto: TransparentAccountDTO) -> TransparentAccount {
        TransparentAccount(
            bankCode: dto.bankCode,
            number: dto.accountNumber
        )
    }
}
