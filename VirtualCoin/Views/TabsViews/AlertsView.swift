//
//  AlertsView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 03/05/2021.
//

import SwiftUI
import UserNotifications
import VirtualCoinKit

struct AlertsView: View {
    @EnvironmentObject private var applicationStateService: ApplicationStateService
    
    @State private var showingSettingsView = false
    @State private var showingAlertView = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Alert.coinId, ascending: true)],
        animation: .default
    )
    private var alerts: FetchedResults<Alert>
    
    var body: some View {
        List {
            ForEach(alerts, id: \.self) { alert in
                let coinViewModelFromApi = applicationStateService.coins.first(where: { coinViewModel in
                    coinViewModel.id == alert.coinId
                })
                
                let coinViewModel = coinViewModelFromApi ?? CoinViewModel(id: "", rank: 1, symbol: "", name: "", priceUsd: 0, changePercent24Hr: 0)
                
                let currency = Currencies.allCurrenciesDictionary[alert.currency] ?? Currency()
                
                let alertViewModel = AlertViewModel(coinViewModel: coinViewModel,
                                                    alert: alert,
                                                    currency: currency)
                
                AlertRowView(alertViewModel: alertViewModel) {
                    applicationStateService.selectedAlertViewModel = alertViewModel
                    self.showingAlertView = true
                }
            }.onDelete(perform: self.deleteItem)
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Alerts")
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
                    applicationStateService.selectedAlertViewModel = nil
                    self.showingAlertView = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingSettingsView) {
            SettingsView()
        }
        .sheet(isPresented: $showingAlertView) {
            if let selectedAlertViewModel = applicationStateService.selectedAlertViewModel {
                EditAlertView(alertViewModel: selectedAlertViewModel).onDisappear {
                    self.grantNotificationPermission()
                }
            } else {
                AddAlertView()
            }
        }
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        let alertsHandler = AlertsHandler()
        
        for index in indexSet {
            let alert = self.alerts[index]
            alertsHandler.deleteAlertEntity(alert: alert)
        }
        
        CoreDataHandler.shared.save()
    }
    
    private func grantNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Authorization was granted: \(success)")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

struct AlertsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AlertsView()
                    .environmentObject(ApplicationStateService.preview)
                    .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
            }
            .preferredColorScheme(.dark)
            
            NavigationView {
                AlertsView()
                    .environmentObject(ApplicationStateService.preview)
                    .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
            }
            .preferredColorScheme(.light)
        }
    }
}
