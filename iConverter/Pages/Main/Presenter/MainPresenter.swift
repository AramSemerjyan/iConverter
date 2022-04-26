//
//  MainPresenter.swift
//  iConverter
//
//  Created by Aram Semerjyan on 13.04.22.
//

import Foundation
import RxRelay

final class MainPresenter: BasePresenter {
    weak var vc: MainViewController?

    func showTransactions(_ transactions: [Transaction]) {
        vc?.viewModel.transactionsHistory.accept(transactions)
    }

    func obser(currentBalance: BehaviorRelay<Balance>) {
        vc?.viewModel.bind(currentBalance: currentBalance)
    }

    func obser(otherBalance: BehaviorRelay<[Balance]>) {
        vc?.viewModel.bind(otherBalances: otherBalance)
    }
}
