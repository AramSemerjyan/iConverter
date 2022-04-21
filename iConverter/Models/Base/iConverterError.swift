//
//  iConverterError.swift
//  iConverter
//
//  Created by Aram Semerjyan on 21.04.22.
//

import Foundation

enum iConverterError: Error {
    enum General: Error {
        case somethingWentWrong
        case canNotBeEmpty
    }

    enum Transaction: Error {
        case noEmptyAmount
        case noFounds
        case noEqualCurrency
    }
}

extension iConverterError.General: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .somethingWentWrong: return iConverterLocalization.somethingWentWrong
        case .canNotBeEmpty: return iConverterLocalization.noEmptyFields
        }
    }
}

extension iConverterError.Transaction: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noEmptyAmount: return iConverterLocalization.noEmptyAmount
        case .noFounds: return iConverterLocalization.noFounds
        case .noEqualCurrency: return iConverterLocalization.noEqualCurrency
        }
    }
}
