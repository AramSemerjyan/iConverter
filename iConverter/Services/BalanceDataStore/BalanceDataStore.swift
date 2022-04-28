//
//  LocalDBService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation
import RxRelay
import NSObject_Rx

protocol BalanceDataStoreProtocol {
    func update(withTransaction transaction: Transaction)
    func loadCurrentCurrency() -> Currency
    func loadCurrentBalance() -> Balance?
    func loadOtherBalances() -> [Balance]
    func loadAllBalances() -> [Balance]
    func loadForCurrency(_ currency: Currency) -> Balance
}

final class BalanceDataStore {
    // MARK: - service
    private let db: LocalDBProtocol
    
    // MARK: - inputs
    let update: PublishRelay<Void> = .init()
    let updateBalance: PublishRelay<Transaction> = .init()
    
    init(db: LocalDBProtocol) {
        self.db = db
    }
}

extension BalanceDataStore: BalanceDataStoreProtocol {

    func update(withTransaction transaction: Transaction) {
        let fromBalance = self.getBalance(for: transaction.fromCurrency)
        let toBalance = self.getBalance(for: transaction.toCurrency)

        self.updateBalance(fromBalance.copy(amount: fromBalance.amount - transaction.priceWithFee))
        self.updateBalance(toBalance.copy(amount: toBalance.amount + (transaction.converted ?? 0.0)))

        update.accept(())
    }

    func loadCurrentCurrency() -> Currency {
        guard let currency = db.get(for: DBKeys.currentBalanceCurrency.rawValue) as? String else {
            return .usd
        }

        return .init(rawValue: currency) ?? .usd
    }

    func loadCurrentBalance() -> Balance? {
        let currentCurrency = loadCurrentCurrency()

        return loadAllBalances().first { $0.currency == currentCurrency }
    }

    func loadOtherBalances() -> [Balance] {
        let balances: [Balance] = loadAllBalances()
        let currentCurrency = loadCurrentCurrency()

        return balances.filter { $0.currency != currentCurrency }
    }

    func loadAllBalances() -> [Balance] {
        var balances: [Balance] = []

        Currency.allCases.forEach { currency in
            balances.append(self.getBalance(for: currency))
        }

        return balances
    }

    func loadForCurrency(_ currency: Currency) -> Balance {
        getBalance(for: currency)
    }
}

private extension BalanceDataStore {

    func getBalance(for currency: Currency) -> Balance {
        guard let balanceAmount = db.get(for: currency.rawValue) as? Double else {
            return .init(currency: currency, amount: 0.0)
        }

        return Balance(currency: currency, amount: balanceAmount)
    }

    func updateBalance(_ balance: Balance) {
        db.set(data: balance.amount, for: balance.currency.rawValue)
    }
}
