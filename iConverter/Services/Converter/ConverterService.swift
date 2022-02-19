//
//  ConverterService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/19/22.
//

import Foundation
import NSObject_Rx
import RxRelay
import RxRestClient

protocol ConverterServiceProtocol {
    var convert: PublishRelay<ConvertRequest> { get }
    var baseState: PublishRelay<BaseState> { get }
    var onSuccess: PublishRelay<String> { get }
}

final class ConverterService: ConverterServiceProtocol, HasDisposeBag {
    let converterApi: ConverterApiProtocol
    
    // MARK: - Inputs
    let convert: PublishRelay<ConvertRequest> = .init()
    
    // MARK: - Outputs
    let baseState = PublishRelay<BaseState>()
    let onSuccess = PublishRelay<String>()
    
    init(converterApi: ConverterApiProtocol) {
        self.converterApi = converterApi
        
        doBindings()
    }
}

// MARK: - Do bindings
extension ConverterService {
    func doBindings() {
        let apiResult = convert
            .flatMap { [converterApi] request in converterApi.convert(with: request) }
            .share()
        
        apiResult.compactMap(\.response)
            .map { "You've converted \($0.amount) to \($0.currency.rawValue)" }
            .bind(to: onSuccess)
            .disposed(by: disposeBag)

        apiResult.compactMap(\.state)
            .bind(to: baseState)
            .disposed(by: disposeBag)
    }
}
