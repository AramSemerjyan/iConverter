//
//  MainViewControllerViewModel.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Foundation
import RxRelay
import RxSwift

final class MainViewModel: BaseViewModel {
    // MARK: - Output
    let currentBalance: BehaviorRelay<String?> = .init(value: nil)
    let otherBalances: BehaviorRelay<[Balance]> = .init(value: [])
    let transactionsHistory: BehaviorRelay<[Transaction]> = .init(value: [])
    let transactionsUpdated = PublishSubject<Void>()
}

// MARK: - bindings
extension MainViewModel {
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
