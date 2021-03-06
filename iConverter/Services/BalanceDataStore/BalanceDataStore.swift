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
    var update: PublishRelay<Void> { get }
    var currenBalance: BehaviorRelay<Balance> { get }
    var updateBalance: PublishRelay<Transaction> { get }
    var otherBalances: BehaviorRelay<[Balance]> { get }
    var currentCurrency: BehaviorRelay<Currency> { get }
    var allBalancies: BehaviorRelay<[Balance]> { get }
}

final class BalanceDataStore: BalanceDataStoreProtocol, HasDisposeBag {
    // MARK: - service
    let db: LocalDBProtocol
    
    // MARK: - inputs
    let update: PublishRelay<Void> = .init()
    let updateBalance: PublishRelay<Transaction> = .init()
    
    // MARK: - outputs
    let currenBalance: BehaviorRelay<Balance> = .init(value: .empty())
    let otherBalances: BehaviorRelay<[Balance]> = .init(value: [])
    let currentCurrency: BehaviorRelay<Currency> = .init(value: .usd)
    let allBalancies: BehaviorRelay<[Balance]> = .init(value: [])
    
    init(db: LocalDBProtocol) {
        self.db = db
        
        doBingings()
        
        update.accept(())
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

// MARK: - do bindings
private extension BalanceDataStore {
    func doBingings() {
        update
            .map { [db] _ -> Currency? in
                guard let currency = db.get(for: DBKeys.currentBalanceCurrency.rawValue) as? String else {
                    return nil
                }
                
                return .init(rawValue: currency)
            }
            .filterNil()
            .bind(to: currentCurrency)
            .disposed(by: disposeBag)
        
        update
            .map { [weak self] _ -> [Balance] in
                var balances: [Balance] = []
                
                Currency.allCases.forEach { currency in
                    if let balance = self?.getBalance(for: currency) {
                        balances.append(balance)
                    }
                }
                
                return balances
            }
            .bind(to: allBalancies)
            .disposed(by: disposeBag)
        
        allBalancies
            .withLatestFrom(currentCurrency) { (currencCurrency: $1, balancies: $0) }
            .map { t in
                t.balancies.first { $0.currency == t.currencCurrency }
            }
            .filterNil()
            .bind(to: currenBalance)
            .disposed(by: disposeBag)
        
        allBalancies
            .withLatestFrom(currentCurrency) { (currencCurrency: $1, balancies: $0) }
            .map { t in
                t.balancies.filter { $0.currency != t.currencCurrency }
            }
            .bind(to: otherBalances)
            .disposed(by: disposeBag)
        
        updateBalance
            .subscribe(onNext: { [weak self] transaction in
                guard let fromBalance = self?.getBalance(for: transaction.fromCurrency) else {
                    return
                }
                
                self?.updateBalance(fromBalance.copy(amount: fromBalance.amount - transaction.priceWithFee))
                
                guard let toBalance = self?.getBalance(for: transaction.toCurrency) else {
                    return
                }
                
                self?.updateBalance(toBalance.copy(amount: toBalance.amount + (transaction.converted ?? 0.0)))
            }).disposed(by: disposeBag)
    }
}
