//
//  TransactionPresenter.swift
//  iConverter
//
//  Created by Aram Semerjyan on 13.04.22.
//

final class TransactionPresenter: BasePresenter {
    weak var vc: TransactionViewController?

    private var viewModel: TransactionViewModel? { vc?.viewModel }

    private var currencyOptions: [Currency] { viewModel?.currencyOptions.value ?? [] }

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
    func onTransactionSuccess(_ transaction: Transaction) {
        resetError()
        stopLoading()
        
        let successMessage = iConverterLocalization.successMessage(transaction)

        viewModel?.onSuccess.accept(successMessage)
    }

    func updateFromCurrency(_ index: Int) {
        viewModel?.selectedFromCurrency.accept(currencyOptions[index])
    }

    func updateToCurrency(_ index: Int) {
        viewModel?.selectedToCurrency.accept(currencyOptions[index])
    }

    func startLoading() {
        viewModel?.startLoading.accept(())
    }

    func stopLoading() {
        viewModel?.stopLoading.accept(())
    }
}
