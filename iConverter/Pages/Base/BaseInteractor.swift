//
//  BaseInteractor.swift
//  iConverter
//
//  Created by Aram Semerjyan on 13.04.22.
//

import RxSwift

class BaseInteractor {
    
    deinit {
        print("********")
        print("Interactor deinited")
        print("********")
    }

    var disposeBag = DisposeBag()
}
