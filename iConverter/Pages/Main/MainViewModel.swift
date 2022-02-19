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
    
    // MARK: - Output
    let onSuccess: PublishRelay<String> = .init()
    let currentBalance: BehaviorRelay<String?> = .init(value: nil)
    let otherBalances: BehaviorRelay<[Balance]> = .init(value: [])
    
    init(
        balanceDataStore: BalanceDataStoreProtocol
    ) {
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

    }
}