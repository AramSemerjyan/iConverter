//
//  MainInteractor.swift
//  iConverter
//
//  Created by Aram Semerjyan on 13.04.22.
//

final class MainInteractor: BaseInteractor {
    var presenter: MainPresenter!

    let historyDataStore: HistoryDataStoreProtocol
    let balanceDataStore: BalanceDataStoreProtocol

    init(
        historyDataStore: HistoryDataStoreProtocol,
        balanceDataStore: BalanceDataStoreProtocol
    ) {
        self.historyDataStore = historyDataStore
        self.balanceDataStore = balanceDataStore
    }

    func loadAndObserveData() {
        loadHistory()
        loadCurrentBalance()
        loadOtherBalances()
    }
}

// MARK: - tap handler
extension MainInteractor {
    func handleAddNewTransactionTap() {
        presenter.openAddNewTransaction()
    }
}

// MARK: - private data manipulation
private extension MainInteractor {
    func loadHistory() {
        historyDataStore.history
            .subscribe(onNext: { [presenter] history in
                presenter?.show(history: history)
            }).disposed(by: disposeBag)
    }

    func loadCurrentBalance() {
        balanceDataStore.currenBalance
            .map { $0.nameWithSymbol }
            .subscribe(onNext: { [presenter] currentBalance in
                presenter?.show(currentBalance: currentBalance)
            })
            .disposed(by: disposeBag)
    }

    func loadOtherBalances() {
        balanceDataStore.otherBalances
            .subscribe(onNext: { [presenter] otherBalance in
                presenter?.show(otherBalance: otherBalance)
            })
            .disposed(by: disposeBag)
    }
}
