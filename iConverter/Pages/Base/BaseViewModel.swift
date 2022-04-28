//
//  BaseViewModel.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import RxRelay
import NSObject_Rx

class BaseViewModel: HasDisposeBag {
    deinit {
        print("********")
        print("View Model deinited")
        print("********")
    }

    // MARK: - Outputs
    let onError: PublishRelay<String?> = .init()
}
