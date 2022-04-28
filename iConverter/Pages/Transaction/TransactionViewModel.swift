//
//  TransactionViewModel.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import RxSwift
import RxRelay

class TransactionViewModel: BaseViewModel {
    // MARK: - Inputs
    let amount: PublishRelay<String> = .init()
    
    // MARK: - Outputs
    let selectedFromCurrency: BehaviorRelay<Currency> = .init(value: .usd)
    let selectedToCurrency: BehaviorRelay<Currency> = .init(value: .eur)
    let currencyOptions: BehaviorRelay<[Currency]> = .init(value: Currency.allCases)
    let onSuccess: PublishRelay<String> = .init()
    let startLoading: PublishRelay<Void> = .init()
    let stopLoading: PublishRelay<Void> = .init()
}
