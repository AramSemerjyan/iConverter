//
//  BalanceItem.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation
import UIKit

final class BalanceItem: UIView {
    // MARK: - outlets
    @IBOutlet weak var balanceCurrencyTitle: UILabel!
    @IBOutlet weak var balanceCurrencyValue: UILabel!
    
    // MARK: - configure
    func configure(_ balance: Balance) {
        balanceCurrencyTitle.text = balance.currency.rawValue
        balanceCurrencyValue.text = iConverterFormater.round(balance.amount)
    }
}
