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
        presenter.obser(history: historyDataStore.history)
    }

    func loadCurrentBalance() {
        presenter.obser(currentBalance: balanceDataStore.currenBalance)
    }

    func loadOtherBalances() {
        presenter.obser(otherBalance: balanceDataStore.otherBalances)
    }
}
