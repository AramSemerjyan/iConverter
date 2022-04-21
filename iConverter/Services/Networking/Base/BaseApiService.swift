//
//  BaseApiService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Foundation

actor BaseAPIService {
    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func make<T: Decodable>(request: APIRequest) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: buildRequest(from: request))

        return try JSONDecoder().decode(T.self, from: data)
    }
}

private extension BaseAPIService {
    func buildRequest(from preRequest: APIRequest) throws -> URLRequest {
        guard let url = URL.init(string: baseURL + preRequest.path) else {
            throw iConverterError.General.somethingWentWrong
        }

        var request = URLRequest.init(url: url)
        request.httpMethod = preRequest.method.rawValue

        return .init(url: url)
    }
}
