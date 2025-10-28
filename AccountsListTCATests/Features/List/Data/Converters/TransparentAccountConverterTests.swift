//
//  TransparentAccountConverterTests.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 28.10.2025.
//

@testable import AccountsListTCA
import Testing

@Suite("TransparentAccountConverterTests")
struct TransparentAccountConverterTests {
    @Test("Convert to domain model")
    func test_givenDTO_whenConvert_thenDomainModelMatched() {
        let dto: TransparentAccountDTO = .makeMock()
        let sut = makeSUT()

        let domainModel = sut.convert(dto: dto)

        #expect(dto.bankCode == domainModel.bankCode)
        #expect(dto.accountNumber == domainModel.number)
    }
}

private extension TransparentAccountConverterTests {
    func makeSUT() -> TransparentAccountConverter {
        TransparentAccountConverterImp()
    }
}
