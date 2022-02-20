//
//  FeeService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

// Here we can have additional fees
// Additional calculation for transaction
protocol FeeServiceProtocol {
    func addFee(for: Transaction) -> Transaction
}

final class FeeService: FeeServiceProtocol {
    let historyService: HistoryServiceProtocol
    
    init(historyService: HistoryServiceProtocol) {
        self.historyService = historyService
    }
    
    func addFee(for transaction: Transaction) -> Transaction {
        let history = historyService.getHistory()
        
        if history.count < iConverterConstants.freeOfFeeCount {
            return transaction.copy(priceWithFee: transaction.original)
        } else {
            return transaction.copy(priceWithFee: transaction.original + transaction.toCurrency.fee)
        }
    }
}
