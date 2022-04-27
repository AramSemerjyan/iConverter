//
//  ViewController.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/15/22.
//

import UIKit
import RxSwift
import RxOptional

class MainViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var currentBalanceTitle: UILabel!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var balancesContainer: BalancesContainer!
    @IBOutlet weak var historyContainer: UIView!
    @IBOutlet weak var historyTableVeiw: UITableView!
    
    // MARK: - View Model
    var viewModel: MainViewModel!
    private var interactor: MainInteractor!
    private var router: MainRouter!

    func makeDI(
        viewModel: MainViewModel,
        interactor: MainInteractor,
        presenter: MainPresenter,
        router: MainRouter
    ) {
        self.viewModel = viewModel
        self.interactor = interactor
        self.router = router
        presenter.vc = self
        interactor.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doBindings()

        interactor.loadData()
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        setUpCurrentBalanceViews()
        setUpHistoryContainer()
        setUpTableView()
    }
    
    @IBAction func addNewTransaction(_ sender: UIButton) {
        router.openAddNewTransaction()
            .rx.transactionUpdated
            .bind(to: viewModel.transactionUpdated)
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - do bindings
private extension MainViewController {
    func doBindings() {
        viewModel
            .currentBalance
            .map { $0?.nameWithSymbol }
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

        viewModel.transactionUpdated
            .bind { [interactor] in
                interactor?.loadData()
            }
            .disposed(by: rx.disposeBag)
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
