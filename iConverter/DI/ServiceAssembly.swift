//
//  ServiceAssembly.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Swinject
import SwinjectAutoregistration

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BaseAPIService.self) { _ in
                .init(baseURL: AppConfigs.dev.converterBaseUrl)
        }
        container.autoregister(ConverterAPIServiceProtocol.self, initializer: ConverterAPIService.init)
        container.autoregister(ConverterServiceProtocol.self, initializer: ConverterService.init)
        container.autoregister(LocalDBProtocol.self, initializer: LocalDBService.init)
        container.autoregister(ConverterValidatorProtocol.self, initializer: ConverterValidator.init)
        container
            .autoregister(BalanceDataStoreProtocol.self, initializer: BalanceDataStore.init)
            .inObjectScope(.container)
        container.autoregister(FeeServiceProtocol.self, initializer: FeeService.init)
        container.autoregister(HistoryDataStoreProtocol.self, initializer: HistoryDataStore.init).inObjectScope(.container)
    }
}
