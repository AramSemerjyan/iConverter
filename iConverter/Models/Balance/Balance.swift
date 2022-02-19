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
    
    var nameWithSymbol: String { currency.symbol + amount.toString() }
    var nameWithCurrency: String { amount.toString() + currency.symbol }
}
