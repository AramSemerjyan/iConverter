//
//  FeeService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation

// Here we can have additional fees
// Additional calculation for transaction
protocol FeeServiceProtocol {
    func addFee(for: Currency, withAmount: Double) -> Double
}

final class FeeService: FeeServiceProtocol {
    func addFee(for currency: Currency, withAmount amount: Double) -> Double {
        amount - currency.fee
    }
}
