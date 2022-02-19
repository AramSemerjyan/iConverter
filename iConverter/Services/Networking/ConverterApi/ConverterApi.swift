//
//  ConverterApi.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import RxRestClient
import RxSwift

protocol ConverterApiProtocol {
    func convert(with: ConvertRequest) -> Observable<ConvertState>
}

final class ConverterApiService: BaseApiService { }

extension ConverterApiService: ConverterApiProtocol {
    func convert(with request: ConvertRequest) -> Observable<ConvertState> {
        client.get(Endpoints.Converter.convert(
            amount: request.amount,
            from: request.fromCurrency,
            to: request.toCurrency
        ))
    }
}
