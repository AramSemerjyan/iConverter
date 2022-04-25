//
//  TransactionInteractor.swift
//  iConverter
//
//  Created by Aram Semerjyan on 13.04.22.
//

import RxSwift
import RxRelay

final class TransactionInteractor: BaseInteractor {

    var presenter: TransactionPresenter!

    // MARK: - services
    let converterService: ConverterServiceProtocol

    init(
        presenter: TransactionPresenter,
        converterService: ConverterServiceProtocol
    ) {
        self.converterService = converterService
        self.presenter = presenter

        super.init()
    }

    func makeTransaction(_ transaction: Transaction) {
        presenter.startLoading()

        Task {
            do {
                let transaction = try await converterService.convert(transaction: transaction)
                await presenter.onTransactionSuccess(transaction)
            } catch {
                await presenter?.show(error: error.localizedDescription)
            }
        }
    }

    func updateFromCurrency(_ index: Int) {
        presenter.updateFromCurrency(index)
    }

    func updateToCurrency(_ index: Int) {
        presenter.updateToCurrency(index)
    }
}
