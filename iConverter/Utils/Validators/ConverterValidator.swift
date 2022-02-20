//
//  ConverterValidator.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/20/22.
//

protocol ConverterValidatorProtocol {
    func validateEmptyAmount(amount: Double?) -> String?
    func validateBalance(transactionAmount: Double?, balance: Double?) -> String?
    func validateCurrencies(fromCurrency: Currency, toCurrency: Currency) -> String?
}

final class ConverterValidator: ConverterValidatorProtocol {
    func validateEmptyAmount(amount: Double?) -> String? {
        guard let amount = amount else { return iConverterLocalization.noEmptyAmount }
        guard amount != 0.0 else { return iConverterLocalization.noEmptyAmount }
        
        return nil
    }
    
    func validateBalance(transactionAmount: Double?, balance: Double?) -> String? {
        guard let transactionAmount = transactionAmount, transactionAmount != 0.0 else {
            return iConverterLocalization.noEmptyAmount
        }
        
        guard let balance = balance, balance != 0.0 else {
            return iConverterLocalization.noFounds
        }
        
        guard transactionAmount < balance else {
            return iConverterLocalization.noFounds
        }

        return nil
    }
    
    func validateCurrencies(fromCurrency: Currency, toCurrency: Currency) -> String? {
        if fromCurrency == toCurrency { return iConverterLocalization.noEqualCurrency }
        
        return nil
    }
}
