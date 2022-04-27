//
//  MainRouter.swift
//  iConverter
//
//  Created by Aram Semerjyan on 13.04.22.
//

import SwinjectAutoregistration

final class MainRouter: Router {
    @discardableResult
    func openAddNewTransaction() -> TransactionViewController {
        let newTransactionController = resolver ~> TransactionViewController.self

        presentWithoutNavigation(newTransactionController)

        return newTransactionController
    }
}
