//
//  ServiceAssembly.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Alamofire
import RxRestClient
import Swinject
import SwinjectAutoregistration

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(Session.self, initializer: provideSession)
        container.autoregister(RxRestClient.self, initializer: provideRestClient)
        container.autoregister(ConverterApiProtocol.self, initializer: ConverterApiService.init)
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

private func provideRestClient(_ session: Session) -> RxRestClient {
    var options = RxRestClientOptions.default

    options.jsonDecoder = iConverterDecoder()
    options.jsonEncoder = iConverterEncoder()
    options.sessionManager = session
    options.queryEncoding = URLEncoding(boolEncoding: .literal)

    return RxRestClient(
        baseUrl: URL(string: AppConfigs.dev.converterBaseUrl),
        options: options
    )
}

private func provideSession() -> Session {
    Session(
        eventMonitors: AppConfigs.dev.debug ? [Logger()] : []
    )
}

private final class Logger: EventMonitor {
    func requestDidResume(_ request: Request) {
        print(request.cURLDescription())
    }
}
