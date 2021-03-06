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
    @IBOutlet weak var historyContainer: UIView!
    @IBOutlet weak var historyTableVeiw: UITableView!
    
    // MARK: - View Model
    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doBindings()
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        setUpCurrentBalanceViews()
        setUpHistoryContainer()
        setUpTableView()
    }
    
    @IBAction func addNewTransaction(_ sender: UIButton) {        
        self.present(resolver ~> TransactionViewController.self, animated: true)
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
            .observe(on: MainScheduler.instance)
            .bind(to: currentBalance.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel
            .otherBalances
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [balancesContainer] balances in
                balancesContainer?.updateBalances(balances)
            }).disposed(by: rx.disposeBag)
        
        viewModel.transactionsHistory
            .observe(on: MainScheduler.instance)
            .bind(to: historyTableVeiw.rx.items) { tv, row, transaction in
                guard let cell = tv.dequeueReusableCell(
                    withIdentifier: HistoryItemCell.name,
                    for: .init(row: row, section: 0)) as? HistoryItemCell
                else {
                    return UITableViewCell()
                }

                cell.configure(with: transaction)
                cell.selectionStyle = .none

                return cell
            }.disposed(by: rx.disposeBag)
    }
}

// MARK: - set up views
private extension MainViewController {
    func setUpCurrentBalanceViews() {
        currentBalanceTitle.textColor = .descriptionTextColor
        currentBalance.textColor = .mainTextColor
    }
    
    func setUpHistoryContainer() {
        historyContainer.clipsToBounds = true
        historyContainer.layer.cornerRadius = 20
        historyContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setUpTableView() {
        let nib = UINib(nibName: HistoryItemCell.name, bundle: nil)
        historyTableVeiw.register(nib, forCellReuseIdentifier: HistoryItemCell.name)
    }
}
