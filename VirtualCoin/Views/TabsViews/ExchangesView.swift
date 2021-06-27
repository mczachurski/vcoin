//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import SwiftUI
import VirtualCoinKit

struct ExchangesView: View {
    @EnvironmentObject private var applicationStateService: ApplicationStateService
    
    @State private var showingSettingsView = false
    @State private var showingExchangeDetailsView = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ExchangeItem.coinId, ascending: true)],
        animation: .default
    )
    private var exchanges: FetchedResults<ExchangeItem>
    
    var body: some View {
        self.mainBody()
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
                    applicationStateService.selectedExchangeViewModel = nil
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
            if let selectedExchangeViewModel = applicationStateService.selectedExchangeViewModel {
                EditExchangeView(exchangeViewModel: selectedExchangeViewModel)
            } else {
                AddExchangeView()
            }
        }
    }
        
    @ViewBuilder
    private func mainBody() -> some View {
        if exchanges.count > 0 {
            List {
                ForEach(exchanges, id: \.self) { exchange in
                    let coinViewModelFromApi = applicationStateService.coins.first(where: { coinViewModel in
                        coinViewModel.id == exchange.coinId
                    })
                    
                    let coinViewModel = coinViewModelFromApi ?? CoinViewModel()
                    
                    let currency = Currencies.allCurrenciesDictionary[exchange.currency] ?? Currency()
                    
                    let exchangeViewModel = ExchangeViewModel(coinViewModel: coinViewModel,
                                                              exchangeItem: exchange,
                                                              currency: currency)

                    ExchangeRowView(exchangeViewModel: exchangeViewModel) {
                        applicationStateService.selectedExchangeViewModel = exchangeViewModel
                        self.showingExchangeDetailsView = true
                    }
                }.onDelete(perform: self.deleteItem)
            }
            .listStyle(PlainListStyle())
        } else {
            NoDataView(title: "No Exchanges", subtitle: "Add exchange") {
                applicationStateService.selectedExchangeViewModel = nil
                self.showingExchangeDetailsView = true
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
        Group {
            NavigationView {
                ExchangesView()
                    .environmentObject(ApplicationStateService.preview)
                    .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
            }
            .preferredColorScheme(.dark)
            
            NavigationView {
                ExchangesView()
                    .environmentObject(ApplicationStateService.preview)
                    .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
            }
            .preferredColorScheme(.light)
        }
    }
}
