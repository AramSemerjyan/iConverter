//
//  ConverterApi.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import RxRestClient
import RxSwift

protocol ConverterApi {
    func convert(with: ConvertRequest) -> Observable<ConvertState>
}

final class ConverterApiService: BaseApiService { }

extension ConverterApiService: ConverterApi {
    func convert(with: ConvertRequest) -> Observable<ConvertState> {
        <#code#>
    }
}
