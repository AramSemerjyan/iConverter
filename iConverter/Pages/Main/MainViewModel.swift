//
//  MainViewControllerViewModel.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Foundation
import RxRelay

final class MainViewModel: BaseViewModel {
    // MARK: - Output
    let currentBalance: BehaviorRelay<String?> = .init(value: nil)
    let otherBalances: BehaviorRelay<[Balance]> = .init(value: [])
    let transactionsHistory: BehaviorRelay<[Transaction]> = .init(value: [])
}

// MARK: - bindings
extension MainViewModel {
    func bind(history: BehaviorRelay<[Transaction]>) {
        history
            .bind(to: transactionsHistory)
            .disposed(by: disposeBag)
    }

    func bind(currentBalance: BehaviorRelay<Balance>) {
        currentBalance
            .map { $0.nameWithSymbol }
            .bind(to: self.currentBalance)
            .disposed(by: disposeBag)
    }

    func bind(otherBalances: BehaviorRelay<[Balance]>) {
        otherBalances
            .bind(to: self.otherBalances)
            .disposed(by: disposeBag)
    }
}
