//
//  ConvertResponse.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

struct ConvertResponse: Decodable {
    let amount: String
    let currency: Currency
}

typealias ConvertState = SingleState<ConvertResponse>
