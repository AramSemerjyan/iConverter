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
            .map { [weak self] request -> Transaction? in
                if let error = self?.validate(request) {
                    self?.onError.accept(error)
                    return nil
                }
                
                return request
            }
            .filterNil()
        
        let afterFee = checkRequest.map { [feeService] request in
            feeService.addFee(for: request)
        }
                
        let response = checkRequest
            .flatMap { [converterApi] request in converterApi.convert(with: request) }
            .share()
        
        let transaction = response.compactMap(\.response)
            .withLatestFrom(afterFee) { $1.copy(converted: $0.amount.toDouble()) }
        
        transaction
            .subscribe(onNext: { [historyService] t in
                historyService.saveTransaction(t.copy(createdDate: .now))
            }).disposed(by: disposeBag)
        
        transaction
            .subscribe(onNext: { [balanceDataStore] t in
                balanceDataStore.update(with: t)
            }).disposed(by: disposeBag)

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
    func validate(_ request: Transaction) -> String? {
        if let error = converterValidator.validateCurrencies(fromCurrency: request.fromCurrency, toCurrency: request.toCurrency) {
            onError.accept(error)
            return error
        }
        
        if let error = converterValidator.validateEmptyAmount(amount: request.original) {
            return error
        }
        
        let balance = balanceDataStore.getBalance(for: request.fromCurrency)
        
        if let error = converterValidator.validateBalance(transactionAmount: request.original, balance: balance.amount) {
            return error
        }
        
        return nil
    }
}
