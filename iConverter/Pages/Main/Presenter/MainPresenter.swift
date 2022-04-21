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

    private let router: MainRouter!

    init(router: MainRouter) {
        self.router = router

        super.init()
    }

    func show(history: [Transaction]) {
        vc?.viewModel.transactionsHistory.accept(history)
    }

    func show(currentBalance: String) {
        vc?.viewModel.currentBalance.accept(currentBalance)
    }

    func show(otherBalance: [Balance]) {
        vc?.viewModel.otherBalances.accept(otherBalance)
    }

    func openAddNewTransaction() {
        router.openAddNewTransaction()
    }
}
