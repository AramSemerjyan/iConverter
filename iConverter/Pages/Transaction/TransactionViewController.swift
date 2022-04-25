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

    private var interactor: TransactionInteractor!

    func makeDI(
        viewModel: TransactionViewModel,
        interactor: TransactionInteractor,
        presenter: TransactionPresenter
    ) {
        self.viewModel = viewModel
        self.interactor = interactor
        presenter.vc = self

        interactor.presenter = presenter
    }
    
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
        bindInputs()
        bindOutputs()
    }
    
    func bindInputs() {
        fromCurrencyButton.rx.tap
            .withLatestFrom(viewModel.currencyOptions)
            .subscribe(onNext: { [weak self] options in
                self?.showActionSheet(actions: options.map { $0.rawValue }, onSelect: { index in
                    self?.interactor.updateFromCurrency(index)
                })
            }).disposed(by: rx.disposeBag)
        
        toCurrencyButton.rx.tap
            .withLatestFrom(viewModel.currencyOptions)
            .subscribe(onNext: { [weak self] options in
                self?.showActionSheet(actions: options.map { $0.rawValue }, onSelect: { index in
                    self?.interactor.updateToCurrency(index)

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
            .subscribe(onNext: { [viewModel] amount in
                viewModel?.amount.accept(amount)
            })
            .disposed(by: rx.disposeBag)
        
        submit.rx.tap
            .withLatestFrom(viewModel.amount)
            .withLatestFrom(viewModel.selectedToCurrency) { (amount: $0, to: $1) }
            .withLatestFrom(viewModel.selectedFromCurrency) { (amount: $0.amount, from: $1, to: $0.to) }
            .subscribe(onNext: { [interactor] t in
                interactor?.makeTransaction(
                    .createWith(
                        amount: t.amount.toDouble(),
                        fromCurrency: t.from,
                        toCurrencty: t.to
                    )
                )
            })
            .disposed(by: rx.disposeBag)
    }
    
    func bindOutputs() {
        viewModel.startLoading
            .bind(to: startLoading)
            .disposed(by: rx.disposeBag)
        
        viewModel.stopLoading
            .bind(to: stopLoading)
            .disposed(by: rx.disposeBag)

        viewModel.onSuccess.subscribe(onNext: { [weak self] message in
            self?.showAlert(title: "Success", message: message)
        }).disposed(by: rx.disposeBag)

        viewModel.onError.subscribe(onNext: { [errorLabel] error in
            errorLabel?.text = error
        }).disposed(by: rx.disposeBag)
    }
}
