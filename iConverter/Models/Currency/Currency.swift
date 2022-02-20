//
//  Currency.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

enum Currency: String, Codable, CaseIterable {
    case usd = "USD"
    case eur = "EUR"
    case jpy = "JPY"
    
    var symbol: String {
        switch (self) {
        case .usd: return "$";
        case .eur: return "€";
        case .jpy: return "¥";
        }
    }
    
    var fee: Double {
        switch (self) {
        case .usd: return 0.7;
        case .eur: return 0.5;
        case .jpy: return 0.8;
        }
    }
}
