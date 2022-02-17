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
        container.autoregister(MainViewModel.self, initializer: MainViewModel.init)
        container.register(MainViewController.self) { r in
            let controller = MainViewController.instantiate()
            controller.viewModel = r ~> MainViewModel.self
            
            return controller
        }
    }
}
