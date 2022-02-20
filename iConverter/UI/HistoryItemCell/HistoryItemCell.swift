//
//  HisteryItemCell.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/20/22.
//

import UIKit

final class HistoryItemCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var fromCurrencyTitle: UILabel!
    @IBOutlet weak var toCurrencyTitle: UILabel!
    @IBOutlet weak var fromBalance: UILabel!
    @IBOutlet weak var toBalance: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - configure
    func configure(with transaction: Transaction) {
        fromCurrencyTitle.text = transaction.fromCurrency.rawValue
        toCurrencyTitle.text = transaction.toCurrency.rawValue
        feeLabel.text = iConverterFormater.totalFeeFormater(transaction.totalFee)
        dateLabel.text = iConverterFormater.dateFormater(transaction.createdDate)
        
        
        fromBalance.text = "-\(transaction.priceWithFee)\(transaction.fromCurrency.symbol)"
        toBalance.text = "+\(transaction.converted ?? 0.0)\(transaction.toCurrency.symbol)"
    }
}
