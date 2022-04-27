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

    func loadData() {
        loadHistory()
        loadCurrentBalance()
        loadOtherBalances()
    }

    func loadHistory() {
        presenter.showHistory(historyDataStore.loadHistory())
    }

    func loadCurrentBalance() {
        guard let currentBalance = balanceDataStore.loadCurrentBalance() else { return }
        presenter.showCurrentBalance(currentBalance)
    }

    func loadOtherBalances() {
        presenter.showOtherBalances(balanceDataStore.loadOtherBalances())
    }
}
