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
    var addFee: PublishSubject<Transaction> { get }
    var updatedTransaction: PublishSubject<Transaction> { get }
}

final class FeeService: FeeServiceProtocol, HasDisposeBag {
    // MARK: - services
    let historyService: HistoryDataStoreProtocol
    
    // MARK: - inputs
    let addFee: PublishSubject<Transaction> = .init()
    
    // MARK: - ouputs
    let updatedTransaction: PublishSubject<Transaction> = .init()
    
    init(historyService: HistoryDataStoreProtocol) {
        self.historyService = historyService
        
        doBindings()
    }
}

// MARK: - do bindings
private extension FeeService {
    func doBindings() {
        addFee
            .withLatestFrom(historyService.history) { (transaction: $0, historyCount: $1.count) }
            .map { t in
                if t.historyCount < iConverterConstants.freeOfFeeCount {
                    return t.transaction.copy(priceWithFee: t.transaction.original)
                } else {
                    return t.transaction.copy(
                        priceWithFee: t.transaction.original + t.transaction.toCurrency.fee,
                        fees: [.init(
                            fee: t.transaction.toCurrency.fee,
                            description: iConverterLocalization.standardTransactionFeeDescription
                        )]
                    )
                }
            }.bind(to: updatedTransaction)
            .disposed(by: disposeBag)
    }
}
