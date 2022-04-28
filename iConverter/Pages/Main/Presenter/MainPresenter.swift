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

    func showHistory(_ history: [Transaction]) {
        vc?.viewModel.transactionsHistory.accept(history)
    }

    func showCurrentBalance(_ currentBalance: Balance?) {
        vc?.viewModel.currentBalance.accept(currentBalance)
    }

    func showOtherBalances(_ otherBalance: [Balance]) {
        vc?.viewModel.otherBalances.accept(otherBalance)
    }
}
