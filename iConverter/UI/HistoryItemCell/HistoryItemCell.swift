//
//  HisteryItemCell.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/20/22.
//

import UIKit

class HistoryItemCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var fromCurrencyTitle: UILabel!
    @IBOutlet weak var toCurrencyTitle: UILabel!
    @IBOutlet weak var fromBalance: UILabel!
    @IBOutlet weak var toBalance: UILabel!
    
    func configure(with transaction: Transaction) {
        fromCurrencyTitle.text = transaction.fromCurrency.rawValue
        toCurrencyTitle.text = transaction.toCurrency.rawValue
        
        fromBalance.text = "-\(transaction.priceWithFee)\(transaction.fromCurrency.symbol)"
        toBalance.text = "+\(transaction.converted ?? 0.0)\(transaction.toCurrency.symbol)"
    }
}
