//
//  BaseViewModel.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import NSObject_Rx
import RxRelay
import RxRestClient

class BaseViewModel: HasDisposeBag {
    // MARK: - Outputs
    let baseState = PublishRelay<BaseState>()
}
