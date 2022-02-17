//
//  BaseViewController.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Foundation
import UIKit
import RxCocoa
import RxOptional
import RxRelay
import RxRestClient
import RxSwift
import NSObject_Rx

class BaseViewController: UIViewController {
    
    // MARK: - Inputs
    let baseState = PublishRelay<BaseState>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doBindings()
    }
}

// MARK: - Do bindings
private extension BaseViewController {
    func doBindings() {
        baseState.map(\.serviceState)
            .filter { $0 == .offline }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.showAlert(
                    title: iConverterLocalization.errorTitle,
                    message: iConverterLocalization.noInternetConnection
                )
            }
            .disposed(by: rx.disposeBag)

        Observable.merge(
            baseState.map(\.badRequest),
            baseState.map(\.unexpectedError),
            baseState.map(\.validationProblem),
            baseState.map(\.forbidden)
        )
        .filterNil()
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] error in
            self?.showAlert(
                title: iConverterLocalization.errorTitle,
                message: iConverterLocalization.errorMessage
            )
        })
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - UI
extension BaseViewController {
    func showAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
