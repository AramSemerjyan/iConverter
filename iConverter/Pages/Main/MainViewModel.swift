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
    let balanceDataStore: BalanceDataStoreProtocol
    let historyDataStore: HistoryDataStoreProtocol
    
    // MARK: - Output
    let onSuccess: PublishRelay<String> = .init()
    let currentBalance: BehaviorRelay<String?> = .init(value: nil)
    let otherBalances: BehaviorRelay<[Balance]> = .init(value: [])
    let transactionsHistory: BehaviorRelay<[Transaction]> = .init(value: [])
    
    init(
        balanceDataStore: BalanceDataStoreProtocol,
        historyDataStore: HistoryDataStoreProtocol
    ) {
        self.balanceDataStore = balanceDataStore
        self.historyDataStore = historyDataStore
        
        super.init()
        
        doBindings()
    }
}

// MARK: - Do bindings
extension MainViewModel {
    func doBindings() {
        historyDataStore.history
            .bind(to: transactionsHistory)
            .disposed(by: disposeBag)
        
        balanceDataStore.currenBalance
            .map { $0.nameWithSymbol }
            .bind(to: currentBalance)
            .disposed(by: disposeBag)
        
        balanceDataStore.otherBalances
            .bind(to: otherBalances)
            .disposed(by: disposeBag)
    }
}
