//
//  iConverterLocalization.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//
import Foundation

final class iConverterLocalization {
    static let errorTitle = NSLocalizedString(
        LocalizationKeys.errorTitle.rawValue,
        comment: "Error Title"
    )
    static let errorMessage = NSLocalizedString(
        LocalizationKeys.errorMessage.rawValue,
        comment: "Error Message"
    )
    static let noInternetConnection = NSLocalizedString(
        LocalizationKeys.noInternetMessage.rawValue,
        comment: "No Internet Connection"
    )
}
