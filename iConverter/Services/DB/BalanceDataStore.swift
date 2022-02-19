//
//  LocalDBService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation
import RxRelay

protocol BalanceDataStoreProtocol {
    func getBalance(for: Currency) -> Balance?
    func getCurrentBalance() -> Balance?
    func getOtherBalances() -> [Balance]
}

final class BalanceDataStore: BalanceDataStoreProtocol {
    let db: LocalDBProtocol
    
    init(db: LocalDBProtocol) {
        self.db = db
    }
    
    func getBalance(for currency: Currency) -> Balance? {
        guard let balanceAmount = db.get(for: currency.rawValue) as? Double else { return nil }
        
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
            if currency != currentCurrency, let balance = getBalance(for: currency) {
                balances.append(balance)
            }
        }
        
        return balances
    }
}
