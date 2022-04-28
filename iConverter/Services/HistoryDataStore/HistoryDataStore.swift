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
    var updateHistory: PublishRelay<Void> { get }
    var history: BehaviorRelay<[Transaction]> { get }

    func save(transaction: Transaction)
}

final class HistoryDataStore: HistoryDataStoreProtocol, HasDisposeBag {
    // MARK: - services
    let localDB: LocalDBProtocol
    
    // MARK: - inputs
    let saveTransaction: PublishRelay<Transaction> = .init()
    let updateHistory: PublishRelay<Void> = .init()
    
    // MARK: - outputs
    let history: BehaviorRelay<[Transaction]> = .init(value: [])
    
    init(localDB: LocalDBProtocol) {
        self.localDB = localDB
        
        doBindings()
        
        updateHistory.accept(())
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

        updateHistory.accept(())
    }
}

// MARK: - do bindings
private extension HistoryDataStore {
    func doBindings() {
        updateHistory
            .map { [localDB] in
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
            .bind(to: history)
            .disposed(by: disposeBag)
    }
}
