//
//  MainRouter.swift
//  iConverter
//
//  Created by Aram Semerjyan on 13.04.22.
//

import SwinjectAutoregistration

final class MainRouter: Router {
    func openAddNewTransaction() {
        let newTransactionController = resolver ~> TransactionViewController.self

        presentWithoutNavigation(newTransactionController)
    }
}
