//
//  Currency.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

enum Currency: String, Decodable {
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
}
