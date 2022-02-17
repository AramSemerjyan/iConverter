//
//  ConverterRequest.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

struct ConvertRequest {
    let amount: String
    let fromCurrency: Currency
    let toCurrency: Currency
}

extension ConvertRequest {
    static func mock() -> ConvertRequest {
        .init(amount: "345.6", fromCurrency: .usd, toCurrency: .eur)
    }
}
