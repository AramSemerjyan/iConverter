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
    // Event called when any type of Request is resumed.
    func requestDidResume(_ request: Request) {
        print(request.cURLDescription())
    }
}
