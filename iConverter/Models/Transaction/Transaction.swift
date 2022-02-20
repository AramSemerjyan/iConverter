//
//  TransactionHistory.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/20/22.
//

import Foundation

struct Transaction: Codable {
    let original: Double
    let priceWithFee: Double
    let converted: Double?
    let createdDate: Date
    let fromCurrency: Currency
    let toCurrency: Currency
    let fees: [Fee]
    
    var totalFee: Double { fees.map { $0.fee }.reduce(0.0, +) }
}

extension Transaction {
    static func mock() -> Transaction {
        .init(
            original: 345.6,
            priceWithFee: 347.6,
            converted: nil,
            createdDate: .now,
            fromCurrency: .usd,
            toCurrency: .eur,
            fees: []
        )
    }

    static func empty() -> Transaction {
        .init(
            original: 0.0,
            priceWithFee: 0.0,
            converted: nil,
            createdDate: .now,
            fromCurrency: .usd,
            toCurrency: .eur,
            fees: []
        )
    }

    func copy(
        original: Double? = nil,
        priceWithFee: Double? = nil,
        converted: Double? = nil,
        createdDate: Date? = nil,
        fromCurrency: Currency? = nil,
        toCurrency: Currency? = nil,
        fees: [Fee]? = nil
    ) -> Transaction {
        .init(
            original: original ?? self.original,
            priceWithFee: priceWithFee ?? self.priceWithFee,
            converted: converted ?? self.converted,
            createdDate: createdDate ?? self.createdDate,
            fromCurrency: fromCurrency ?? self.fromCurrency,
            toCurrency: toCurrency ?? self.toCurrency,
            fees: fees ?? self.fees
        )
    }
}

typealias TransactionState = SingleState<Transaction>
