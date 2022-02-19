//
//  ViewController.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/15/22.
//

import UIKit
import SwinjectAutoregistration
import RxSwift

class MainViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var currentBalanceTitle: UILabel!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var balancesContainer: BalancesContainer!
    
    // MARK: - View Model
    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doBindings()
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        setUpCurrentBalanceViews()
    }
    
    @IBAction func addNewTransaction(_ sender: UIButton) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let controller = delegate.parentAssembler.resolver ~> TransactionViewController.self
        
        self.present(controller, animated: true)
    }
}

// MARK: - do bindings
private extension MainViewController {
    func doBindings() {
        viewModel.onSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(title: iConverterLocalization.appName, message: message)
            }).disposed(by: rx.disposeBag)
        
        viewModel
            .currentBalance
            .filterNil()
            .bind(to: currentBalance.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel
            .otherBalances
            .subscribe(onNext: { [balancesContainer] balances in
                balancesContainer?.updateBalances(balances)
            }).disposed(by: rx.disposeBag)
    }
}

// MARK: - set up views
private extension MainViewController {
    func setUpCurrentBalanceViews() {
        currentBalanceTitle.textColor = .descriptionTextColor
        currentBalance.textColor = .mainTextColor
    }
}
