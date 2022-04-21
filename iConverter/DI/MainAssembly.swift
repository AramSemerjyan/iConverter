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
        container.register(MainViewController.self) { r in
            let controller = MainViewController.instantiate()
            controller.makeDI(
                viewModel: r ~> MainViewModel.self,
                interactor: r ~> MainInteractor.self,
                presenter: r ~> MainPresenter.self
            )

            return controller
        }

        // MARK: - Transactions
        container.autoregister(TransactionInteractor.self, initializer: TransactionInteractor.init)
        container.autoregister(TransactionPresenter.self, initializer: TransactionPresenter.init)
        container.autoregister(
            TransactionViewModel.self,
            initializer: TransactionViewModel.init
        )
        container.register(TransactionViewController.self) { r in
            let controller = TransactionViewController.instantiate()
            controller.makeDI(
                viewModel: r ~> TransactionViewModel.self,
                interactor: r ~> TransactionInteractor.self,
                presenter: r ~> TransactionPresenter.self
            )
            
            return controller
        }
    }
}
