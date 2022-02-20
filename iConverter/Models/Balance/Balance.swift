//
//  Balance.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation

struct Balance {
    let currency: Currency
    let amount: Double
    
    var nameWithSymbol: String { "\(currency.symbol) " + String(format: "%.2f", amount) }
    var nameWithCurrency: String { "\(amount.toString()) \(currency.symbol)" }
}

extension Balance {
    static func empty() -> Balance {
        .init(currency: .usd, amount: 0.0)
    }
    
    func copy(
        currency: Currency? = nil,
        amount: Double? = nil
    ) -> Balance {
        .init(
            currency: currency ?? self.currency,
            amount: amount ?? self.amount
        )
    }
}
