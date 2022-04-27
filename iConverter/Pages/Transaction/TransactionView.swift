//
//  TransactionView.swift
//  iConverter
//
//  Created by Aram Semerjyan on 27.04.22.
//

import UIKit
import Stevia

final class TransactionView: UIView {
    private static var tintedButton: UIButton { UIButton.init(configuration: .tinted()) }

    let titleLabel = UILabel()
    let amountField = UITextField()
    let stackView = UIStackView()
    let fromCurrencyLabel = UILabel()
    let fromCurrencyButton = tintedButton
    let toCurrencyLabel = UILabel()
    let toCurrencyButton = tintedButton
    let submitButton = tintedButton
    let errorLabel = UILabel()

    convenience init() {
        self.init(frame:CGRect.zero)

        configure()
    }
}

// MARK: - configure
private extension TransactionView {
    func configure() {
        backgroundColor = .appBackground

        configureSubviews()
        configureLayout()

        addInStackView([
            fromCurrencyLabel,
            fromCurrencyButton,
            toCurrencyLabel,
            toCurrencyButton
        ])
    }

    func configureSubviews() {
        subviews {
            titleLabel.style(titleStyle)
            amountField.style(textFieldStyle)
            stackView.style(stackViewStyle)
            fromCurrencyLabel.style(currencyLabelStyle).style(fromCurrencyLabelStyle)
            fromCurrencyButton.style(currencyButtonStyle)
            toCurrencyLabel.style(currencyLabelStyle).style(toCurrencyLabelStyle)
            toCurrencyButton.style(currencyButtonStyle)
            submitButton.style(submitButtonStyle)
            errorLabel.style(errorLabelStyle)
        }
    }

    func configureLayout() {
        layout {
            40
            |-20-titleLabel-|
            30
            |-20-amountField-20-|
            18
            |-20-stackView-20-|
            8
            |-20-submitButton-20-|
            8
            |-20-errorLabel-20-|
        }
    }

    func addInStackView(_ views: [UIView]) {
        views.forEach { view in
            stackView.addArrangedSubview(view)
        }
    }
}

// MARK: - styles
private extension TransactionView {
    func titleStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 35.0)
        label.textColor = .mainTextColor

        label.text = iConverterLocalization.transactionTitle
    }

    func textFieldStyle(_ field: UITextField) {
        field.borderStyle = .roundedRect
        field.keyboardType = .numberPad
    }

    func stackViewStyle(_ stackView: UIStackView) {
        stackView.distribution = .equalSpacing
    }

    func currencyLabelStyle(_ label: UILabel) {
        label.textColor = .mainTextColor
    }

    func fromCurrencyLabelStyle(_ label: UILabel) {
        label.text = iConverterLocalization.fromLabelTitle
    }

    func toCurrencyLabelStyle(_ label: UILabel) {
        label.text = iConverterLocalization.toLabelTitle
    }

    func currencyButtonStyle(_ button: UIButton) {
        button.tintColor = .mainTextColor
    }

    func submitButtonStyle(_ button: UIButton) {
        button.tintColor = .mainTextColor
        button.setTitle(iConverterLocalization.submitButtonTitle, for: .normal)
    }

    func errorLabelStyle(_ label: UILabel) {
        label.textColor = .errorColor
    }
}
