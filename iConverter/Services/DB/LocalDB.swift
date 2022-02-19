//
//  LocalDB.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation

enum DBKeys: String {
    case currentBalance
    case currentBalanceCurrency
}

protocol LocalDBProtocol {
    func initialSetUp()
    func get(for: String) -> Any?
    func set(data: Any, for: String)
}

final class LocalDBService: LocalDBProtocol {
    private let standard = UserDefaults.standard
    
    func initialSetUp() {
//        if standard.string(forKey: DBKeys.currentBalanceCurrency.rawValue) == nil {
            standard.set(1000.0, forKey: Currency.usd.rawValue)
            standard.set(Currency.usd.rawValue, forKey: DBKeys.currentBalanceCurrency.rawValue)
        
        standard.set(0.0, forKey: Currency.jpy.rawValue)
        standard.set(0.0, forKey: Currency.eur.rawValue)
//        }
    }
    
    func get(for key: String) -> Any? {
        standard.value(forKey: key)
    }
    
    func set(data: Any, for key: String) {
        standard.setValue(data, forKey: key)
    }
}
