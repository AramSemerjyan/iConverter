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
    
    static func successMessage(_ transaction: Transaction) -> String {
        let original = "\(transaction.original) \(transaction.fromCurrency.rawValue)"
        let converted = "\(transaction.converted ?? 0.0) \(transaction.toCurrency.rawValue)"
        let fee = "\(transaction.totalFee) \(transaction.fromCurrency.rawValue)"
        let localizedString = NSLocalizedString(LocalizationKeys.successMessage.rawValue, comment: "")
        
        return String(format: localizedString, original, converted, fee)
    }
    
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
    
    static let standardTransactionFeeDescription = NSLocalizedString(
        LocalizationKeys.standardTransactionFeeDescription.rawValue,
        comment: "Standard commission"
    )

    // MARK: - errors
    static let somethingWentWrong = NSLocalizedString(
        LocalizationKeys.somethingWentWrong.rawValue,
        comment: "Something went wrong"
    )
}
