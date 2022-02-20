//
//  LocalDBService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation
import RxRelay

protocol BalanceDataStoreProtocol {
    func update(with transaction: Transaction)
    func updateBalance(_ balance: Balance)
    func getBalance(for: Currency) -> Balance
    func getCurrentBalance() -> Balance?
    func getOtherBalances() -> [Balance]
}

final class BalanceDataStore: BalanceDataStoreProtocol {
    let db: LocalDBProtocol
    
    init(db: LocalDBProtocol) {
        self.db = db
    }
    
    func update(with transaction: Transaction) {
        let fromBalance = getBalance(for: transaction.fromCurrency)
        
        updateBalance(fromBalance.copy(amount: fromBalance.amount - transaction.priceWithFee))
        
        let toBalance = getBalance(for: transaction.toCurrency)
        
        updateBalance(toBalance.copy(amount: toBalance.amount + (transaction.converted ?? 0.0)))
    }
    
    func updateBalance(_ balance: Balance) {
        db.set(data: balance.amount, for: balance.currency.rawValue)
    }
    
    func getBalance(for currency: Currency) -> Balance {
        guard let balanceAmount = db.get(for: currency.rawValue) as? Double else {
            return .init(currency: currency, amount: 0.0)
        }
        
        return Balance(currency: currency, amount: balanceAmount)
    }
    
    func getCurrentCurrency() -> Currency? {
        guard let currentCurrencyString = db.get(for: DBKeys.currentBalanceCurrency.rawValue) as? String,
                let currentCurrency = Currency.init(rawValue: currentCurrencyString)
        else {
            return nil
        }
        
        return currentCurrency
    }
    
    func getCurrentBalance() -> Balance? {
        guard let currentCurrency = getCurrentCurrency() else {
            return nil
        }
        guard let currentBalanceAmount = db.get(for: currentCurrency.rawValue) as? Double
        else { return nil }
        
        return Balance(currency: currentCurrency, amount: currentBalanceAmount)
    }
    
    func getOtherBalances() -> [Balance] {
        var balances: [Balance] = []
        
        guard let currentCurrency = getCurrentCurrency() else {
            return balances
        }
        
        Currency.allCases.forEach { currency in
            if currency != currentCurrency {
                let balance = getBalance(for: currency)
                balances.append(balance)
            }
        }
        
        return balances
    }
}
