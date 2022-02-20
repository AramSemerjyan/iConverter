//
//  ConverterService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation
import NSObject_Rx
import RxRelay
import RxRestClient

protocol ConverterServiceProtocol {
    var convert: PublishRelay<Transaction> { get }
    var baseState: PublishRelay<BaseState> { get }
    var onSuccess: PublishRelay<Transaction> { get }
    var onError: PublishRelay<String> { get }
}

final class ConverterService: ConverterServiceProtocol, HasDisposeBag {
    // MARK: - services
    let converterApi: ConverterApiProtocol
    let balanceDataStore: BalanceDataStoreProtocol
    let feeService: FeeServiceProtocol
    let historyService: HistoryServiceProtocol
    
    // MARK: - validator
    let converterValidator: ConverterValidatorProtocol
    
    // MARK: - Inputs
    let convert: PublishRelay<Transaction> = .init()
    
    // MARK: - Outputs
    let baseState = PublishRelay<BaseState>()
    let onSuccess = PublishRelay<Transaction>()
    let onError = PublishRelay<String>()
    
    init(
        converterApi: ConverterApiProtocol,
        balanceDataStore: BalanceDataStoreProtocol,
        converterValidator: ConverterValidatorProtocol,
        feeService: FeeServiceProtocol,
        historyService: HistoryServiceProtocol
    ) {
        self.converterApi = converterApi
        self.balanceDataStore = balanceDataStore
        self.converterValidator = converterValidator
        self.feeService = feeService
        self.historyService = historyService
        
        doBindings()
    }
}

// MARK: - Do bindings
extension ConverterService {
    func doBindings() {
        let checkRequest = convert
            .withLatestFrom(balanceDataStore.allBalancies) { transaction, balancies -> (transaction: Transaction, balance: Balance)? in
                let balance = balancies.first { $0.currency == transaction.fromCurrency }
                guard let balance = balance else {
                    return nil
                }
                return (transaction, balance)
            }
            .filterNil()
            .map { [weak self] t -> Transaction? in
                if let error = self?.validate(t.transaction, balance: t.balance) {
                    self?.onError.accept(error)
                    return nil
                }
                
                return t.transaction
            }
            .filterNil()
        
        checkRequest
            .bind(to: feeService.addFee)
            .disposed(by: disposeBag)
        
        let afterFee = feeService.updatedTransaction
                
        let response = checkRequest
            .flatMap { [converterApi] request in converterApi.convert(with: request) }
            .share()
        
        let transaction = response.compactMap(\.response)
            .withLatestFrom(afterFee) { $1.copy(converted: $0.amount.toDouble()) }
        
        transaction
            .map { $0.copy(createdDate: .now) }
            .bind(to: historyService.saveTransaction)
            .disposed(by: disposeBag)
        
        transaction
            .subscribe(onNext: { [balanceDataStore] t in
                balanceDataStore.updateBalance.accept(t)
                balanceDataStore.update.accept(())
            }).disposed(by: disposeBag)
        
        transaction
            .map { _ in () }
            .bind(to: historyService.updateHistory)
            .disposed(by: disposeBag)

        transaction
            .bind(to: onSuccess)
            .disposed(by: disposeBag)

        response.compactMap(\.state)
            .bind(to: baseState)
            .disposed(by: disposeBag)
    }
}

// MARK: - validations
private extension ConverterService {
    func validate(_ request: Transaction, balance: Balance) -> String? {
        if let error = converterValidator.validateCurrencies(fromCurrency: request.fromCurrency, toCurrency: request.toCurrency) {
            onError.accept(error)
            return error
        }
        
        if let error = converterValidator.validateEmptyAmount(amount: request.original) {
            return error
        }
        
        if let error = converterValidator.validateBalance(transactionAmount: request.original, balance: balance.amount) {
            return error
        }
        
        return nil
    }
}
