//
//  HistoryService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/20/22.
//

import Foundation
import RxRelay
import NSObject_Rx

protocol HistoryServiceProtocol {
    var updateHistory: PublishRelay<Void> { get }
    var saveTransaction: PublishRelay<Transaction> { get }
    var history: BehaviorRelay<[Transaction]> { get }
}

final class HistoryService: HistoryServiceProtocol, HasDisposeBag {
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
}

// MARK: - do bindings
private extension HistoryService {
    func doBindings() {
        saveTransaction
            .withLatestFrom(history) { (transaction: $0, history: $1) }
            .subscribe(onNext: { [localDB] t in
                var history = t.history
                history.append(t.transaction)
                
                guard let data = try? iConverterEncoder().encode(history) else {
                    return
                }
                
                localDB.set(data: data, for: DBKeys.transactionHistory.rawValue)
            }).disposed(by: disposeBag)
        
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

