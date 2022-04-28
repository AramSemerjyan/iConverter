//
//  HisteryItemCell.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/20/22.
//

import UIKit
import Stevia

final class HistoryItemCell: UITableViewCell {
    // MARK: - Outlets
    let fromCurrencyTitle = UILabel()
    let toCurrencyTitle = UILabel()
    let fromBalance = UILabel()
    let toBalance = UILabel()
    let feeLabel = UILabel()
    let dateLabel = UILabel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }
    
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

// MARK: - configure
private extension HistoryItemCell {
    func configure() {
        configureSubviews()
        configureLayout()
    }

    func configureSubviews() {
        subviews {
            fromCurrencyTitle.style(fromCurrencyTitleLabelStyle)
            toCurrencyTitle.style(toCurrencyTitleLabelStyle)
            fromBalance.style(fromBalanceLabelStyle)
            toBalance.style(toBalanceTitleLabelStyle)
            feeLabel.style(italicLabelStyle)
            dateLabel.style(italicLabelStyle)
        }
    }

    func configureLayout() {
        layout {
            5
            |-8-fromCurrencyTitle-(>=5)-fromBalance-8-|
            10
            |-8-toCurrencyTitle-(>=5)-toBalance-8-|
            10
            |-8-dateLabel-(>=5)-feeLabel-8-|
            13
        }
    }
}

// MARK: - styles
private extension HistoryItemCell {
    func fromCurrencyTitleLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 21)
    }

    func fromBalanceLabelStyle(_ label: UILabel) {
        label.textColor = .errorColor
    }

    func toCurrencyTitleLabelStyle(_ label: UILabel) {
        label.textColor = .secondaryLabel
    }

    func toBalanceTitleLabelStyle(_ label: UILabel) {
        label.textColor = .successColor
    }

    func italicLabelStyle(_ label: UILabel) {
        label.textColor = .secondaryLabel
        label.font = UIFont.italicSystemFont(ofSize: 17)
    }
}
