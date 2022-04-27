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

    // MARK: - view
    var mainView: MainView! {
        didSet {
            configureTableView()
        }
    }

    // MARK: - View Model
    var viewModel: MainViewModel!

    private var interactor: MainInteractor!
    private var router: MainRouter!

    init(
        viewModel: MainViewModel,
        interactor: MainInteractor,
        presenter: MainPresenter,
        router: MainRouter
    ) {
        self.viewModel = viewModel
        self.interactor = interactor
        self.router = router

        super.init(nibName: nil, bundle: nil)

        presenter.vc = self
        interactor.presenter = presenter
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        mainView = MainView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doBindings()

        interactor.loadData()
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
            .subscribe(onNext: { [mainView] balance in
                mainView?.setCurrentBalance(balance)
            })
            .disposed(by: rx.disposeBag)

        mainView.addNewButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.router.openAddNewTransaction()
                    .rx.transactionUpdated
                    .bind(to: self.viewModel.transactionUpdated)
                    .disposed(by: rx.disposeBag)
            }).disposed(by: rx.disposeBag)

        viewModel
            .otherBalances
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [mainView] otherBalances in
                mainView?.setUpOtherBalances(otherBalances)
            }).disposed(by: rx.disposeBag)

        viewModel.transactionsHistory
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.historyTableView.rx.items) { tv, row, transaction in
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
    func configureTableView() {
        mainView.historyTableView.register(HistoryItemCell.self, forCellReuseIdentifier: HistoryItemCell.name)
    }
}
