//
//  ConverterService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation
import RxRelay
import NSObject_Rx

protocol ConverterServiceProtocol {
    func convert(transaction: Transaction) async throws -> Transaction
}

final class ConverterService: ConverterServiceProtocol, HasDisposeBag {
    // MARK: - services
    let convertAPIService: ConverterAPIServiceProtocol
    let balanceDataStore: BalanceDataStoreProtocol
    let feeService: FeeServiceProtocol
    let historyService: HistoryDataStoreProtocol
    
    // MARK: - validator
    let converterValidator: ConverterValidatorProtocol
    
    init(
        convertAPIService: ConverterAPIServiceProtocol,
        balanceDataStore: BalanceDataStoreProtocol,
        converterValidator: ConverterValidatorProtocol,
        feeService: FeeServiceProtocol,
        historyService: HistoryDataStoreProtocol
    ) {
        self.convertAPIService = convertAPIService
        self.balanceDataStore = balanceDataStore
        self.converterValidator = converterValidator
        self.feeService = feeService
        self.historyService = historyService
    }

    func convert(transaction: Transaction) async throws -> Transaction {
        let allBalance = balanceDataStore.loadAllBalances()
        let balance = allBalance.first { $0.currency == transaction.fromCurrency }

        try validate(transaction, balance: balance)

        let response = try await convertAPIService.convert(transaction: transaction)

        let transactionWithFee = feeService.addFee(forTransaction: transaction.copy(converted: response.amount.toDouble()))

        balanceDataStore.update(withTransaction: transactionWithFee)
        historyService.save(transaction: transactionWithFee)

        return transactionWithFee
    }
}

// MARK: - validations
private extension ConverterService {
    func validate(_ transaction: Transaction?, balance: Balance?) throws {
        try converterValidator.validateCurrencies(fromCurrency: transaction?.fromCurrency, toCurrency: transaction?.toCurrency)

        try converterValidator.validateEmptyAmount(amount: transaction?.original)

        try converterValidator.validateBalance(transactionAmount: transaction?.original, balance: balance?.amount)
    }
}
