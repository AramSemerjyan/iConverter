//
//  MainViewStavia.swift
//  iConverter
//
//  Created by Aram Semerjyan on 27.04.22.
//

import UIKit
import Stevia

class MainView: UIView {
    let balanceTitle = UILabel()
    let currentBalanceLabel = UILabel()
    let addNewButton = UIButton()

    let balancesContainer = BalancesContainer()

    let historyContainer = UIView()
    let historyTableView = UITableView()

    convenience init() {
        self.init(frame:CGRect.zero)

        configure()
    }

    func setCurrentBalance(_ balance: String?) {
        currentBalanceLabel.text = balance
    }

    func setUpOtherBalances(_ otherBalances: [Balance]) {
        balancesContainer.configure(with: otherBalances)
    }
}

//MARK: - configure
private extension MainView {
    func configure() {
        configureSubviews()
        configureLayout()
    }

    func configureSubviews() {
        subviews {
            balanceTitle.style(titleLabelStyle)
            currentBalanceLabel.style(currentBalanceLableStyle)
            balancesContainer
            historyContainer.style(historyContainerStyle).subviews {
                historyTableView
            }
            addNewButton.style(addNewButtonStyle)
        }
    }

    func configureLayout() {
        layout {
            80
            |-20-balanceTitle-5-addNewButton-20-|
            10
            |-20-currentBalanceLabel-5-|
            20
            |-20-balancesContainer.height(62)-20-|
            20
            |historyContainer|
            0
        }

        historyContainer.layout {
            30
            |-8-historyTableView-8-|
            42
        }
    }
}

// MARK: - styles
private extension MainView {
    func titleLabelStyle(_ label: UILabel) {
        label.textColor = .mainTextColor

        label.text = iConverterLocalization.currentBalance
    }

    func currentBalanceLableStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 35.0)
        label.textColor = .mainTextColor
    }

    func historyContainerStyle(_ container: UIView) {
        container.backgroundColor = .mainTextColor
        container.clipsToBounds = true
        container.layer.cornerRadius = 20
        container.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    func addNewButtonStyle(_ button: UIButton) {
        button.setTitleColor(.mainTextColor, for: .normal)
        button.tintColor = .mainTextColor
        button.setImage(.addNewIcon, for: .normal)
    }
}
