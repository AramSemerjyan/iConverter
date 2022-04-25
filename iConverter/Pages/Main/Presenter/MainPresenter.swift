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

    func obserHistory(_ history: BehaviorRelay<[Transaction]>) {
        vc?.viewModel.bind(history: history)
    }

    func obserCurrentBalance(_ currentBalance: BehaviorRelay<Balance>) {
        vc?.viewModel.bind(currentBalance: currentBalance)
    }

    func obserOtherBalances(_ otherBalance: BehaviorRelay<[Balance]>) {
        vc?.viewModel.bind(otherBalances: otherBalance)
    }

    func openAddNewTransaction() {
        router.openAddNewTransaction()
    }
}
