//
//  iConverterLocalization.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//
import Foundation

final class iConverterLocalization {
    
    // MARK: - Error
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
    
    // MARK: - Success
    static let successTitle = NSLocalizedString(
        LocalizationKeys.successTitle.rawValue,
        comment: "Success Title"
    )
    
    // MARK: - App Name
    static let appName = NSLocalizedString(
        LocalizationKeys.appName.rawValue,
        comment: "App Name"
    )
}
