//
//  APIRequest.swift
//  iConverter
//
//  Created by Aram Semerjyan on 21.04.22.
//

import Foundation

enum RequestMethod: String {
    case GET
}

enum RequestError: Error {
    case incorrectURL
    case somethingWentWrong
}

protocol APIRequest {
    var method: RequestMethod { get }
    var path: String { get }
}
