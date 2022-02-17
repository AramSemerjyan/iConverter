//
//  MainViewControllerViewModel.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Foundation
import RxRelay

final class MainViewModel: BaseViewModel {
    // MARK: - Services
    let converterApi: ConverterApiProtocol
    
    // MARK: - Output
    let onSuccess: PublishRelay<String> = .init()
    
    init(converterApi: ConverterApiProtocol) {
        self.converterApi = converterApi
        super.init()
        
        doBindings()
    }
}

// MARK: - Do bindings
extension MainViewModel {
    func doBindings() {
        let state = converterApi
            .convert(with: .mock())
            .share()
        
        state.compactMap(\.response)
            .map { "You've converted \($0.amount) to \($0.currency)" }
            .bind(to: onSuccess)
            .disposed(by: disposeBag)
        
        state.compactMap(\.state)
            .bind(to: baseState)
            .disposed(by: disposeBag)
    }
}
