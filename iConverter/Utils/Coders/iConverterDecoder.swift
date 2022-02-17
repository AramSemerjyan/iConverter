//
//  iConverterDecoder.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Foundation

final class iConverterDecoder: JSONDecoder {
    override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
    }
}
