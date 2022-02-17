//
//  ViewController.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/15/22.
//

import UIKit
import RxSwift

class MainViewController: BaseViewController {
    
    // MARK: - View Model
    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doBindings()
    }
}

private extension MainViewController {
    func doBindings() {
        viewModel.onSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(title: iConverterLocalization.appName, message: message)
            }).disposed(by: rx.disposeBag)
    }
}

