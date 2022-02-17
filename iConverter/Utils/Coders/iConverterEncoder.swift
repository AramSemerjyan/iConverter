//
//  iConverterEncoder.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Foundation

final class iConverterEncoder: JSONEncoder {
    override init() {
        super.init()
        self.keyEncodingStrategy = .convertToSnakeCase
    }
}
