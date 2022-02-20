//
//  iConverterFormater.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/20/22.
//

import Foundation

final class iConverterFormater {
    static func totalFeeFormater(_ fee: Double) -> String {
        if fee == 0.0 { return "Fee Free" }
        
        return "Fee: \(fee)"
    }
    
//    static func transactionResult(_ transaction: Transaction) -> String {
//
//    }
    
    static func dateFormater(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        return formatter.string(from: date)
    }
}
