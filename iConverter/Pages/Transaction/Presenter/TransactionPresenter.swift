//
//  TransactionPresenter.swift
//  iConverter
//
//  Created by Aram Semerjyan on 13.04.22.
//

final class TransactionPresenter: BasePresenter {
    weak var vc: TransactionViewController?

    var viewModel: TransactionViewModel? { vc?.viewModel }

    var currencyOptions: [Currency] { viewModel?.currencyOptionsUpdated ?? [] }

    @MainActor
    func show(error: String) {
        stopLoading()
        viewModel?.onError.accept(error)
    }

    @MainActor
    func resetError() {
        viewModel?.onError.accept(nil)
    }

    @MainActor
    func onSuccess(transaction: Transaction) {
        resetError()
        stopLoading()
        
        let successMessage = iConverterLocalization.successMessage(transaction)

        viewModel?.onSuccess.accept(successMessage)
    }

    func update(fromCurrency index: Int) {
        viewModel?.selectedFromCurrency.accept(currencyOptions[index])
    }

    func update(toCurrency index: Int) {
        viewModel?.selectedToCurrency.accept(currencyOptions[index])
    }

    func update(amount: String) {
        viewModel?.amount.accept(amount)
    }

    func startLoading() {
        viewModel?.startLoading.accept(())
    }

    func stopLoading() {
        viewModel?.stopLoading.accept(())
    }
}
