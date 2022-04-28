//
//  MainAssembly.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Swinject
import SwinjectAutoregistration

final class MainAssembly: Assembly {
    func assemble(container: Container) {

        // MARK: - Home
        container.autoregister(MainRouter.self, initializer: MainRouter.init).inObjectScope(.container)
        container.autoregister(MainInteractor.self, initializer: MainInteractor.init)
        container.autoregister(MainPresenter.self, initializer: MainPresenter.init)
        container.autoregister(MainViewModel.self, initializer: MainViewModel.init)
        container.autoregister(MainViewController.self, initializer: MainViewController.init)

        // MARK: - Transactions
        container.autoregister(TransactionInteractor.self, initializer: TransactionInteractor.init)
        container.autoregister(TransactionPresenter.self, initializer: TransactionPresenter.init)
        container.autoregister(TransactionViewModel.self, initializer: TransactionViewModel.init)
        container.autoregister(TransactionViewController.self, initializer: TransactionViewController.init)
    }
}
