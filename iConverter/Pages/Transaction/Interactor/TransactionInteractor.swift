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

    func makeA(transaction: Transaction) {
        presenter.startLoading()

        Task {
            do {
                let transaction = try await converterService.convert(transaction: transaction)
                await presenter.onSuccess(transaction: transaction)
            } catch {
                await presenter?.show(error: error.localizedDescription)
            }
        }
    }

    func update(fromCurrency index: Int) {
        presenter.update(fromCurrency: index)
    }

    func update(toCurrency index: Int) {
        presenter.update(toCurrency: index)
    }

    func update(amount: String) {

    }
}
