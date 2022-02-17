//
//  AppConfigs.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Foundation

// Here can be other schemes that we need
// alpha/beta/prod
enum AppConfigs: String {
    case dev
    case live
    
    var debug: Bool {
        switch self {
        case .live: return false
        default: return true
        }
    }
    
    var converterBaseUrl: String { "http://api.evp.lt/" }
}
