//
//  ExchangesView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 03/05/2021.
//

import SwiftUI
import VirtualCoinKit

struct ExchangesView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var showingSettingsView = false
    @State private var showingExchangeDetailsView = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ExchangeItem.coinSymbol, ascending: true)],
        animation: .default
    )
    private var exchanges: FetchedResults<ExchangeItem>
    
    var body: some View {
        List {
            ForEach(exchanges, id: \.self) { exchange in                
                let coinViewModelFromApi = self.appViewModel.coins?.first(where: { coinViewModel in
                    coinViewModel.symbol == exchange.coinSymbol
                })
                
                let coinViewModel = coinViewModelFromApi ?? CoinViewModel(id: "", rank: 1, symbol: "", name: "", priceUsd: 0, changePercent24Hr: 0)
                
                let currency = Currencies.allCurrenciesDictionary[exchange.currency]
                    ?? Currency(id: "", locale: "", name: "")
                
                let exchangeViewModel = ExchangeViewModel(coinViewModel: coinViewModel,
                                                          exchangeItem: exchange,
                                                          currency: currency)

                ExchangeRowView(exchangeViewModel: exchangeViewModel)
                    .onTapGesture {
                         self.appViewModel.selectedExchangeViewModel = exchangeViewModel
                         self.showingExchangeDetailsView = true
                    }
            }.onDelete(perform: self.deleteItem)
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Exchanges")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showingSettingsView.toggle()
                }) {
                    Image(systemName: "switch.2")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.appViewModel.selectedExchangeViewModel = nil
                    self.showingExchangeDetailsView = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingSettingsView) {
            SettingsView()
        }
        .sheet(isPresented: $showingExchangeDetailsView) {
            if let selectedExchangeViewModel = self.appViewModel.selectedExchangeViewModel {
                EditExchangeView(exchangeViewModel: selectedExchangeViewModel)
            } else {
                AddExchangeView()
            }
        }
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        let exchangeItemsHandler = ExchangeItemsHandler()
        
        for index in indexSet {
            let exchangeItem = self.exchanges[index]
            exchangeItemsHandler.deleteExchangeItemEntity(exchangeItem: exchangeItem)
        }
        
        CoreDataHandler.shared.save()
    }
}

struct ExchangesView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangesView()
            .environmentObject(AppViewModel())
    }
}
