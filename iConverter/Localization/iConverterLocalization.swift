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
    
    static let noEmptyFields = NSLocalizedString(
        LocalizationKeys.noEmptyFields.rawValue,
        comment: "No empty fields"
    )
    
    static let noEmptyAmount = NSLocalizedString(
        LocalizationKeys.noEmptyAmount.rawValue,
        comment: "No empty amount"
    )
    
    static let noEqualCurrency = NSLocalizedString(
        LocalizationKeys.noEqualCurrency.rawValue,
        comment: "No equal currency"
    )
    
    static let noFounds = NSLocalizedString(
        LocalizationKeys.noFounds.rawValue,
        comment: "No founds"
    )
    
    // MARK: - Success
    static let successTitle = NSLocalizedString(
        LocalizationKeys.successTitle.rawValue,
        comment: "Success Title"
    )
    
    static let successMessage = NSLocalizedString(
        LocalizationKeys.successMessage.rawValue,
        comment: "Success Message"
    )
    
    // MARK: - App Name
    static let appName = NSLocalizedString(
        LocalizationKeys.appName.rawValue,
        comment: "App Name"
    )
    
    // MARK: - Balance
    static let currentBalance = NSLocalizedString(
        LocalizationKeys.currentBalance.rawValue,
        comment: "Current Balance"
    )
    
    // MARK: - Transaction
    static let transactionTitle = NSLocalizedString(
        LocalizationKeys.transactionTitle.rawValue,
        comment: "Transaction Title"
    )
    
    static let submitButtonTitle = NSLocalizedString(
        LocalizationKeys.submitButtonTitle.rawValue,
        comment: "Submit button title"
    )
}
