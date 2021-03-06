//
//  TransactionViewModel.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import RxSwift
import RxRelay

class TransactionViewModel: BaseViewModel {
    
    // MARK: - services
    let converterService: ConverterServiceProtocol
    
    // MARK: - Inputs
    let amount: PublishRelay<String> = .init()
    let selectFromCurrency: PublishRelay<Int> = .init()
    let selectToCurrency: PublishRelay<Int> = .init()
    let transaction: BehaviorRelay<Transaction> = .init(value: .empty())
    let convert: PublishRelay<Void> = .init()
    let isValid: BehaviorRelay<Bool> = .init(value: false)
    
    // MARK: - Outputs
    let selectedFromCurrency: BehaviorRelay<Currency> = .init(value: .usd)
    let selectedToCurrency: BehaviorRelay<Currency> = .init(value: .eur)
    let currencyOptions: BehaviorRelay<[Currency]> = .init(value: Currency.allCases)
    let onSuccess: PublishRelay<String> = .init()
    let startLoading: PublishRelay<Void> = .init()
    let stopLoading: PublishRelay<Void> = .init()

    init(converterService: ConverterServiceProtocol) {
        self.converterService = converterService
        
        super.init()
        
        doBindings()
    }
}

// MARK: - do bindings
private extension TransactionViewModel {
    func doBindings() {
        selectFromCurrency
            .withLatestFrom(currencyOptions) { $1[$0] }
            .bind(to: selectedFromCurrency)
            .disposed(by: disposeBag)
        
        selectToCurrency
            .withLatestFrom(currencyOptions) { $1[$0] }
            .bind(to: selectedToCurrency)
            .disposed(by: disposeBag)
        
        Observable.merge([
            selectedFromCurrency
                .withLatestFrom(transaction) { fromCurrency, transaction in transaction.copy(fromCurrency: fromCurrency) },
            selectedToCurrency
                .withLatestFrom(transaction) { toCurrency, transaction in transaction.copy(toCurrency: toCurrency) },
            amount
                .withLatestFrom(transaction) { amount, transaction in transaction.copy(original: amount.toDouble()) }
        ])
        .bind(to: transaction)
        .disposed(by: disposeBag)
        
        converterService.onSuccess
            .do(onNext: { [stopLoading] _ in stopLoading.accept(()) })
            .map { iConverterLocalization.successMessage($0) }
            .bind(to: onSuccess)
            .disposed(by: disposeBag)
        
        convert
            .do(onNext: { [startLoading] in startLoading.accept(()) })
            .do(onNext: { [onError] in onError.accept(nil) })
            .withLatestFrom(transaction)
            .bind(to: converterService.convert)
            .disposed(by: disposeBag)
                
        
        converterService.onError
            .do(onNext: { [stopLoading] _ in stopLoading.accept(()) })
            .bind(to: onError)
            .disposed(by: disposeBag)
        
        converterService.baseState
            .do(onNext: { [stopLoading] _ in stopLoading.accept(()) })
            .bind(to: baseState)
            .disposed(by: disposeBag)
    }
}
