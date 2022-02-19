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
    let balanceService: BalanceDataStoreProtocol
    let convertValidator: ConverterValidatorProtocol
    
    // MARK: - Inputs
    let amount: PublishRelay<String> = .init()
    let selectFromCurrency: PublishRelay<Int> = .init()
    let selectToCurrency: PublishRelay<Int> = .init()
    let transaction: BehaviorRelay<ConvertRequest> = .init(value: .empty())
    let convert: PublishRelay<Void> = .init()
    let isValid: BehaviorRelay<Bool> = .init(value: false)
    
    // MARK: - Outputs
    let selectedFromCurrency: BehaviorRelay<Currency> = .init(value: .usd)
    let selectedToCurrency: BehaviorRelay<Currency> = .init(value: .eur)
    let currencyOptions: BehaviorRelay<[Currency]> = .init(value: Currency.allCases)
    let currencyValidation: BehaviorRelay<String?> = .init(value: nil)
    let balanceValidation: BehaviorRelay<String?> = .init(value: nil)
    let amountValidation: BehaviorRelay<String?> = .init(value: nil)
    let onError: PublishRelay<String?> = .init()

    init(
        converterService: ConverterServiceProtocol,
        balancService: BalanceDataStoreProtocol,
        convertValidator: ConverterValidatorProtocol
    ) {
        self.converterService = converterService
        self.balanceService = balancService
        self.convertValidator = convertValidator
        
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
        
        amount
            .map { [convertValidator] amount in
                convertValidator.validateEmptyAmount(amount: amount.toDouble())
            }
            .bind(to: amountValidation)
            .disposed(by: disposeBag)
        
        amount
            .withLatestFrom(selectedFromCurrency) { (currency: $1, amount: $0) }
            .map { [convertValidator, balanceService] t -> String? in
                let balance = balanceService.getBalance(for: t.currency)
                
                return convertValidator.validateBalance(
                    transactionAmount: t.amount.toDouble(),
                    balance: balance?.amount
                )
            }.bind(to: balanceValidation)
            .disposed(by: disposeBag)
        
        selectedFromCurrency
            .withLatestFrom(selectedToCurrency) { [convertValidator] from, to -> String? in
                convertValidator.validateCurrencies(fromCurrency: from, toCurrency: to)
            }
            .bind(to: currencyValidation)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(amountValidation, balanceValidation, currencyValidation) { (a, b, c) -> String? in
            if a != nil { return a }
            if b != nil { return b }
            if c != nil { return c }
            return nil
        }
        .bind(to: onError)
        .disposed(by: disposeBag)
    }
}
