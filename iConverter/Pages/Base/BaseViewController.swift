//
//  BaseViewController.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Foundation
import UIKit
import RxCocoa
import RxRelay
import RxSwift

class BaseViewController: UIViewController {
    
    // MARK: - Inputs
    let startLoading: PublishRelay<Void> = .init()
    let stopLoading: PublishRelay<Void> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doBindings()
        setUpViews()
    }
    
    func setUpViews() {
        self.view.backgroundColor = .appBackground
    }
}

// MARK: - Do bindings
private extension BaseViewController {
    func doBindings() {
        startLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.addLoaderView()
            }).disposed(by: rx.disposeBag)
        
        stopLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.removeLoader()
            }).disposed(by: rx.disposeBag)
    }
}

// MARK: - loader view
private extension BaseViewController {
    func addLoaderView() {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        
        let containerView = UIView(frame: view.frame)
        indicator.center = containerView.center
        containerView.backgroundColor = .overlaySemiTransparent
        
        containerView.addSubview(indicator)
        containerView.tag = ViewTag.activityIndicatorContainer.rawValue
        
        view.addSubview(containerView)
    }
    
    func removeLoader() {
        self.view.viewWithTag(ViewTag.activityIndicatorContainer.rawValue)?.removeFromSuperview()
    }
}

// MARK: - UI
extension BaseViewController {
    func showAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func showActionSheet(
        title: String? = nil,
        message: String? = nil,
        actions: [String],
        onSelect: @escaping (Int) -> Void
    ) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for i in 0..<actions.count {
            let action = UIAlertAction(title: actions[i], style: .default) { (action) in
                onSelect(i)
            }
            
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("didPress cancel")
        }
        
        actionSheet.addAction(cancelAction)

        self.present(actionSheet, animated: true, completion: nil)
    }
}
