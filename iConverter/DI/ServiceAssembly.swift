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
        container.autoregister(RxRestClient.self, initializer: provideRestClient)
    }
}

private func provideRestClient(_ session: Session) -> RxRestClient {
    var options = RxRestClientOptions.default

    options.jsonDecoder = iConverterDecoder()
    options.jsonEncoder = DefaultEncoder()
    options.sessionManager = session
    options.queryEncoding = URLEncoding(boolEncoding: .literal)

    return RxRestClient(baseUrl: URL(string: Config.BASE_URL), options: options)
}
