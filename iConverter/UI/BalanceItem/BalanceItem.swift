//
//  BalanceItem.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import UIKit
import Stevia

final class BalanceItem: UIView {
    // MARK: - items
    let balanceCurrencyTitle = UILabel()
    let balanceCurrencyValue = UILabel()

    convenience init() {
        self.init(frame:CGRect.zero)

        configure()
    }
    
    // MARK: - configure
    func configure(with balance: Balance) {
        balanceCurrencyTitle.text = balance.currency.rawValue
        balanceCurrencyValue.text = iConverterFormater.round(balance.amount)
    }
}

// MARK: - configure
private extension BalanceItem {
    func configure() {
        configureSubviews()
        configureLayout()
    }

    func configureSubviews() {
        subviews {
            balanceCurrencyTitle.style(labelStyle)
            balanceCurrencyValue.style(labelStyle)
        }
    }

    func configureLayout() {
        layout {
            |balanceCurrencyTitle.height(30)|
            |balanceCurrencyValue|
        }
    }
}

// MARK: - styles
private extension BalanceItem {
    func labelStyle(_ label: UILabel) {
        label.textColor = .white
        label.textAlignment = .center
    }
}
