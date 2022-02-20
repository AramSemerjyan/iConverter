//
//  HistoryService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/20/22.
//

import Foundation

protocol HistoryServiceProtocol {
    func saveTransaction(_ transaction: Transaction)
    func getHistory() -> [Transaction]
}

final class HistoryService: HistoryServiceProtocol {
    let localDB: LocalDBProtocol
    
    init(localDB: LocalDBProtocol) {
        self.localDB = localDB
    }
    
    func saveTransaction(_ transaction: Transaction) {
        var history = getHistory()
        history.append(transaction)
        
        guard let data = try? iConverterEncoder().encode(history) else {
            return
        }
        
        localDB.set(data: data, for: DBKeys.transactionHistory.rawValue)
    }
    
    func getHistory() -> [Transaction] {
        guard let data = localDB.get(for: DBKeys.transactionHistory.rawValue) as? Data else {
            return []
        }
        
        if let decoded = try? iConverterDecoder().decode([Transaction].self, from: data) {
            return decoded
        }
    
        return []
    }
}

