//
//  Endpoints.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

enum Endpoints {
    enum Converter {
        static func convert(amount: String, from: Currency, to: Currency) -> String {
            "currency/commercial/exchange/\(amount)-\(from.rawValue)/\(to.rawValue)/latest"
        }
    }
}
