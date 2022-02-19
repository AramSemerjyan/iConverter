//
//  TransactionViewController.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation
import UIKit
import RxSwift

class TransactionViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var pageTitle: UILabel!
    
    @IBOutlet weak var fromAmountField: UITextField!
    @IBOutlet weak var fromCurrencyButton: UIButton!
    @IBOutlet weak var toCurrencyButton: UIButton!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - view model
    var viewModel: TransactionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doBindings()
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        setUpPage()
        setUpButtons()
        setUpFields()
        setUpSubmitButton()
        setUpErrorLabel()
    }
}

// MARK: - set up views
private extension TransactionViewController {
    func setUpPage() {
        pageTitle.text = iConverterLocalization.transactionTitle
        pageTitle.textColor = .mainTextColor
    }
    
    func setUpButtons() {
        toCurrencyButton.tintColor = .mainTextColor
        fromCurrencyButton.tintColor = .mainTextColor
    }
    
    func setUpFields() {
        fromAmountField.keyboardType = .numberPad
    }
    
    func setUpSubmitButton() {
        submit.tintColor = .mainTextColor
        submit.setTitle(iConverterLocalization.submitButtonTitle, for: .normal)
    }
    
    func setUpErrorLabel() {
        errorLabel.textColor = .errorColor
    }
}

// MARK: - do bindings
private extension TransactionViewController {
    func doBindings() {
        fromCurrencyButton.rx.tap
            .withLatestFrom(viewModel.currencyOptions)
            .subscribe(onNext: { [weak self] options in
                self?.showActionSheet(actions: options.map { $0.rawValue }, onSelect: { index in
                    self?.viewModel.selectFromCurrency.accept(index)
                })
            }).disposed(by: rx.disposeBag)
        
        toCurrencyButton.rx.tap
            .withLatestFrom(viewModel.currencyOptions)
            .subscribe(onNext: { [weak self] options in
                self?.showActionSheet(actions: options.map { $0.rawValue }, onSelect: { index in
                    self?.viewModel.selectToCurrency.accept(index)
                })
            }).disposed(by: rx.disposeBag)
        
        viewModel.selectedFromCurrency
            .map { $0.rawValue }
            .bind(to: fromCurrencyButton.rx.title())
            .disposed(by: rx.disposeBag)
        
        viewModel.selectedToCurrency
            .map { $0.rawValue }
            .bind(to: toCurrencyButton.rx.title())
            .disposed(by: rx.disposeBag)
        
        fromAmountField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.amount)
            .disposed(by: rx.disposeBag)
        
        viewModel
            .onError
            .bind(to: errorLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
}
