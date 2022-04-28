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
    func loadHistory() -> [Transaction]
}

final class HistoryDataStore {
    // MARK: - services
    private let localDB: LocalDBProtocol
    
    init(localDB: LocalDBProtocol) {
        self.localDB = localDB
    }
}

extension HistoryDataStore: HistoryDataStoreProtocol {
    func save(transaction: Transaction) {
        let data = localDB.get(for: DBKeys.transactionHistory.rawValue) as? Data

        var history: [Transaction] = []

        if let data = data, let decoded = try? iConverterDecoder().decode([Transaction].self, from: data) {
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

    func loadHistory() -> [Transaction] {
        guard let data = localDB.get(for: DBKeys.transactionHistory.rawValue) as? Data else {
            return []
        }

        if let decoded = try? iConverterDecoder().decode([Transaction].self, from: data) {
            return decoded.sorted { a, b in
                a.createdDate > b.createdDate
            }
        }

        return []
    }
}
