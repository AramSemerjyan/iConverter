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
    
    func loadHistory() {
        presenter.showTransactions(historyDataStore.loadTransactions())
    }
}

// MARK: - private data manipulation
private extension MainInteractor {
    func loadCurrentBalance() {
        presenter.obser(currentBalance: balanceDataStore.currenBalance)
    }

    func loadOtherBalances() {
        presenter.obser(otherBalance: balanceDataStore.otherBalances)
    }
}
