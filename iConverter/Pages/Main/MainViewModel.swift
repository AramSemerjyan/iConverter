//
//  MainViewControllerViewModel.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Foundation
import RxRelay

final class MainViewModel: BaseViewModel {
    // MARK: - Services
    let converterSerivce: ConverterServiceProtocol
    let balanceDataStore: BalanceDataStoreProtocol
    
    // MARK: - Output
    let onSuccess: PublishRelay<String> = .init()
    let currentBalance: BehaviorRelay<String?> = .init(value: nil)
    let otherBalances: BehaviorRelay<[Balance]> = .init(value: [])
    
    init(
        converterService: ConverterServiceProtocol,
        balanceDataStore: BalanceDataStoreProtocol
    ) {
        self.converterSerivce = converterService
        self.balanceDataStore = balanceDataStore
        
        super.init()
        
        initData()
        doBindings()
    }
}

// MARK: - Init data
extension MainViewModel {
    func initData() {
        let currentBalance = balanceDataStore.getCurrentBalance()
        let otherBalances = balanceDataStore.getOtherBalances()
        
        self.currentBalance.accept(currentBalance?.nameWithSymbol)
        self.otherBalances.accept(otherBalances)
    }
}

// MARK: - Do bindings
extension MainViewModel {
    func doBindings() {
        converterSerivce.convert.accept(.mock())
        
        converterSerivce
            .onSuccess
            .bind(to: onSuccess)
            .disposed(by: disposeBag)

        converterSerivce.baseState
            .bind(to: baseState)
            .disposed(by: disposeBag)
    }
}
