//
//  TransactionRequest.swift
//  iConverter
//
//  Created by Aram Semerjyan on 21.04.22.
//

import Foundation

enum TransactionRequest: APIRequest {

    case convert(Transaction)

    var method: RequestMethod {
        .GET
    }

    var path: String {
        switch self {
        case .convert(let transaction):
            return Endpoints.Converter.convert(
                amount: transaction.original.toString(),
                from: transaction.fromCurrency,
                to: transaction.toCurrency
            )
        }
    }
}
