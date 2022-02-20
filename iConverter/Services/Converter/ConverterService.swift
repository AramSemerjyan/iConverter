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
    var convert: PublishRelay<ConvertRequest> { get }
    var baseState: PublishRelay<BaseState> { get }
    var onSuccess: PublishRelay<String> { get }
    var onError: PublishRelay<String> { get }
}

final class ConverterService: ConverterServiceProtocol, HasDisposeBag {
    // MARK: - services
    let converterApi: ConverterApiProtocol
    let balanceDataStore: BalanceDataStoreProtocol
    
    // MARK: - validator
    let converterValidator: ConverterValidatorProtocol
    
    // MARK: - Inputs
    let convert: PublishRelay<ConvertRequest> = .init()
    
    // MARK: - Outputs
    let baseState = PublishRelay<BaseState>()
    let onSuccess = PublishRelay<String>()
    let onError = PublishRelay<String>()
    
    init(
        converterApi: ConverterApiProtocol,
        balanceDataStore: BalanceDataStoreProtocol,
        converterValidator: ConverterValidatorProtocol
    ) {
        self.converterApi = converterApi
        self.balanceDataStore = balanceDataStore
        self.converterValidator = converterValidator
        
        doBindings()
    }
}

// MARK: - Do bindings
extension ConverterService {
    func doBindings() {
        let response = convert
            .map { [weak self] request -> ConvertRequest? in
                if let error = self?.validate(request) {
                    self?.onError.accept(error)
                    return nil
                }
                
                return request
            }
            .filterNil()
            .flatMap { [converterApi] request in converterApi.convert(with: request) }
            .share()
        
        response.compactMap(\.response)
            .map { "You've converted \($0.amount) to \($0.currency.rawValue)" }
            .bind(to: onSuccess)
            .disposed(by: disposeBag)

        response.compactMap(\.state)
            .bind(to: baseState)
            .disposed(by: disposeBag)
    }
}

// MARK: - validations
private extension ConverterService {
    func validate(_ request: ConvertRequest) -> String? {
        if let error = converterValidator.validateCurrencies(fromCurrency: request.fromCurrency, toCurrency: request.toCurrency) {
            onError.accept(error)
            return error
        }
        
        if let error = converterValidator.validateEmptyAmount(amount: request.amount.toDouble()) {
            return error
        }
        
        let balance = balanceDataStore.getBalance(for: request.fromCurrency)
        
        if let error = converterValidator.validateBalance(transactionAmount: request.amount.toDouble(), balance: balance?.amount) {
            return error
        }
        
        return nil
    }
}
