//
//  SingleState.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import RxRestClient

class SingleState<T: Decodable>: ResponseState {
    typealias Body = Data

    var isSuccess: Bool { response != nil }
    var state: BaseState?
    var response: T?

    required init(state: BaseState) {
        self.state = state
    }

    required init(response: (HTTPURLResponse, Data?)) {
        self.state = BaseState.online
        if (200..<300).contains(response.0.statusCode), let data = response.1 {
            do {
                self.response = try iConverterDecoder().decode(T.self, from: data)
            } catch {
                self.state = BaseState(unexpectedError: error)
            }
        } else {
            self.state = BaseState(unexpectedError: response.1)
        }
    }
}
