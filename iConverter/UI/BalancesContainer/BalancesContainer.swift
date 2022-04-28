//
//  BalancesContainer.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import UIKit
import Stevia

final class BalancesContainer: UIView {
    let stackView = UIStackView()

    convenience init() {
        self.init(frame:CGRect.zero)

        configure()
    }

    // MARK: - update container
    func configure(with balances: [Balance]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        balances.forEach { balance in
            if let item = getContainerItem(balance) {
                stackView.addArrangedSubview(item)
            }
        }
    }
}

// MARK: - configure
private extension BalancesContainer {
    func configure() {
        backgroundColor = .clear

        configureSubviews()
        configureLayout()
    }

    func configureSubviews() {
        subviews {
            stackView.style(stackViewStyle)
        }
    }

    func configureLayout() {
        layout {
            0
            |stackView|
            0
        }
    }
}

// MARK: - styles
private extension BalancesContainer {
    func stackViewStyle(_ stackView: UIStackView) {
        stackView.distribution = .fillEqually
    }
}

// MARK: - get items
private extension BalancesContainer {
    func getContainerItem(_ balance: Balance) -> BalanceItem? {
        let item = BalanceItem()
        
        item.configure(with: balance)
        
        return item
    }
}
