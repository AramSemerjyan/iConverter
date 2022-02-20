//
//  BalancesContainer.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation
import UIKit

final class BalancesContainer: UIView {
    @IBOutlet weak var stackConainer: UIStackView!
    
    func updateBalances(_ balances: [Balance]) {
        stackConainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        balances.forEach { balance in
            if let item = getContainerItem(balance) {
                stackConainer.addArrangedSubview(item)
            }
        }
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        addSubview(view)
        setUpViews()
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Self.name, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

// MARK: - set up views
private extension BalancesContainer {
    func setUpViews() {
        self.backgroundColor = .clear
    }
}

private extension BalancesContainer {
    func getContainerItem(_ balance: Balance) -> BalanceItem? {
        guard let item = Bundle.main.loadNibNamed(
            BalanceItem.name,
            owner: nil,
            options: nil)?.first as? BalanceItem else { return nil }
        
        item.configure(balance)
        
        return item
    }
}
