//
//  HistoryService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/20/22.
//

import Foundation
import RxRelay
import NSObject_Rx

protocol HistoryDataStoreProtocol {
    func save(transaction: Transaction)
    func loadTransactions() -> [Transaction]
}

final class HistoryDataStore: HistoryDataStoreProtocol {
    // MARK: - services
    private let localDB: LocalDBProtocol
    
    init(localDB: LocalDBProtocol) {
        self.localDB = localDB
    }

    func save(transaction: Transaction) {
        guard let data = localDB.get(for: DBKeys.transactionHistory.rawValue) as? Data else {
            return
        }

        var history: [Transaction] = []

        if let decoded = try? iConverterDecoder().decode([Transaction].self, from: data) {
            history = decoded.sorted { a, b in
                a.createdDate > b.createdDate
            }
        }

        history.append(transaction)

        guard let data = try? iConverterEncoder().encode(history) else {
            return
        }

        localDB.set(data: data, for: DBKeys.transactionHistory.rawValue)
    }
    
    func loadTransactions() -> [Transaction] {
        guard
            let data = localDB.get(for: DBKeys.transactionHistory.rawValue) as? Data,
            let decoded = try? iConverterDecoder().decode([Transaction].self, from: data)
        else {
            return []
        }
        return decoded
    }
}
