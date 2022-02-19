//
//  String+Extension.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/20/22.
//

import Foundation

extension String {
    func toDouble() -> Double {
        (self as NSString).doubleValue
    }
    
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
