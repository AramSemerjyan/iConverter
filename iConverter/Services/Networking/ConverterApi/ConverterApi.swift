//
//  ConverterApi.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Foundation

enum ConverterError: Error {
    case urlIssue
    case noData
}

extension ConverterError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .urlIssue: return "Incorrect URL provided"
        case .noData: return "No data to transfer"
        }
    }
}

protocol ConverterAPIServiceProtocol {
    func convert(transaction: Transaction) async throws -> ConvertResponse
}

actor ConverterAPIService: ConverterAPIServiceProtocol {

    let baseService: BaseAPIService

    init(baseService: BaseAPIService) {
        self.baseService = baseService
    }

    func convert(transaction: Transaction) async throws -> ConvertResponse {
        try await baseService.make(request: TransactionRequest.convert(transaction))
    }
}
