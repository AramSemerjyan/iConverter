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

    // MARK: - view
    var transactionView: TransactionView!
    
    // MARK: - view model
    var viewModel: TransactionViewModel!

    private var interactor: TransactionInteractor!

    init(
        viewModel: TransactionViewModel,
        interactor: TransactionInteractor,
        presenter: TransactionPresenter
    ) {
        self.viewModel = viewModel
        self.interactor = interactor

        super.init(nibName: nil, bundle: nil)

        presenter.vc = self
        interactor.presenter = presenter
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        transactionView = TransactionView()
        view = transactionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doBindings()
    }
}

// MARK: - do bindings
private extension TransactionViewController {
    func doBindings() {
        bindInputs()
        bindOutputs()
    }
    
    func bindInputs() {
        transactionView.fromCurrencyButton.rx.tap
            .withLatestFrom(viewModel.currencyOptions)
            .subscribe(onNext: { [weak self] options in
                self?.showActionSheet(actions: options.map { $0.rawValue }, onSelect: { index in
                    self?.interactor.updateFromCurrency(index)
                })
            }).disposed(by: rx.disposeBag)
        
        transactionView.toCurrencyButton.rx.tap
            .withLatestFrom(viewModel.currencyOptions)
            .subscribe(onNext: { [weak self] options in
                self?.showActionSheet(actions: options.map { $0.rawValue }, onSelect: { index in
                    self?.interactor.updateToCurrency(index)

                })
            }).disposed(by: rx.disposeBag)
        
        viewModel.selectedFromCurrency
            .map { $0.rawValue }
            .bind(to: transactionView.fromCurrencyButton.rx.title())
            .disposed(by: rx.disposeBag)
        
        viewModel.selectedToCurrency
            .map { $0.rawValue }
            .bind(to: transactionView.toCurrencyButton.rx.title())
            .disposed(by: rx.disposeBag)
        
        transactionView.amountField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [viewModel] amount in
                viewModel?.amount.accept(amount)
            })
            .disposed(by: rx.disposeBag)
        
        transactionView.submitButton.rx.tap
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
            self?.showAlert(title: iConverterLocalization.successTitle, message: message)
        }).disposed(by: rx.disposeBag)

        viewModel.onError
            .bind(to: transactionView.errorLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
}

extension Reactive where Base: TransactionViewController {
     var transactionUpdated: Observable<Void> {
         base.viewModel.onSuccess
             .map { _ in Void() }
             .asObservable()
     }
 }
