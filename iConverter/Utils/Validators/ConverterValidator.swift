//
//  ConverterValidator.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/20/22.
//

protocol ConverterValidatorProtocol {
    func validateEmptyAmount(amount: Double?) throws
    func validateBalance(transactionAmount: Double?, balance: Double?) throws
    func validateCurrencies(fromCurrency: Currency?, toCurrency: Currency?) throws
}

final class ConverterValidator: ConverterValidatorProtocol {
    func validateEmptyAmount(amount: Double?) throws {
        guard let amount = amount else { throw iConverterError.Transaction.noEmptyAmount }
        guard amount != 0.0 else { throw iConverterError.Transaction.noEmptyAmount }
    }
    
    func validateBalance(transactionAmount: Double?, balance: Double?) throws {
        guard let transactionAmount = transactionAmount, transactionAmount != 0.0 else {
            throw iConverterError.Transaction.noEmptyAmount
        }
        
        guard let balance = balance, balance != 0.0 else {
            throw iConverterError.Transaction.noFounds
        }
        
        guard transactionAmount < balance else {
            throw iConverterError.Transaction.noFounds
        }
    }
    
    func validateCurrencies(fromCurrency: Currency?, toCurrency: Currency?) throws {
        if fromCurrency == toCurrency { throw iConverterError.Transaction.noEqualCurrency }
    }
}
