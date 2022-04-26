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

    let currencyOptionsUpdated: [Currency] = Currency.allCases

    init(converterService: ConverterServiceProtocol) {
        self.converterService = converterService
        
        super.init()
        
        doBindings()
    }
}

// MARK: - do bindings
private extension TransactionViewModel {
    func doBindings() {
        Observable.merge([
            selectedFromCurrency
                .withLatestFrom(transaction) { fromCurrency, transaction in transaction.copy(fromCurrency: fromCurrency) },
            selectedToCurrency
                .withLatestFrom(transaction) { toCurrency, transaction in transaction.copy(toCurrency: toCurrency) },
            amount
                .withLatestFrom(transaction) { amount, transaction in transaction.copy(original: amount.toDouble()) }
        ])
            .subscribe(onNext: { [weak self] updatedTransaction in
                //self?.transactionUpdated = updatedTransaction
            })
        .disposed(by: disposeBag)
    }
}
