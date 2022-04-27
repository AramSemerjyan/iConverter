//
//  FeeService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import RxSwift
import NSObject_Rx

// Here we can have additional fees
// Additional calculation for transaction
protocol FeeServiceProtocol {
    func addFee(forTransaction transaction: Transaction) -> Transaction
}

final class FeeService: FeeServiceProtocol, HasDisposeBag {
    // MARK: - services
    let historyService: HistoryDataStoreProtocol
    
    init(historyService: HistoryDataStoreProtocol) {
        self.historyService = historyService
    }

    func addFee(forTransaction transaction: Transaction) -> Transaction {
        let history = historyService.loadHistory()
        let updatedTransaction = transaction

        if history.count < iConverterConstants.freeOfFeeCount {
            return updatedTransaction.copy(priceWithFee: transaction.original)
        } else {
            return updatedTransaction.copy(
                priceWithFee: transaction.original + transaction.toCurrency.fee,
                fees: [.init(
                    fee: transaction.toCurrency.fee,
                    description: iConverterLocalization.standardTransactionFeeDescription
                )]
            )
        }
    }
}
