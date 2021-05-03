//
//  AlertsView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 03/05/2021.
//

import SwiftUI

struct AlertsView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var appViewModel: AppViewModel

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Alert.coinSymbol, ascending: true)],
        animation: .default
    )
    private var alerts: FetchedResults<Alert>
    
    var body: some View {
        List(alerts, id: \.objectID) { alert in
            Text(alert.coinSymbol)
//            NavigationLink(destination: CoinView(coin: coin).environmentObject(appViewModel)) {
//                CoinRowView(coin: coin).environmentObject(appViewModel)
//            }
        }
        .navigationTitle("Alerts")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    print("Settings button was tapped")
                }) {
                    Image(systemName: "switch.2")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Add button was tapped")
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct AlertsView_Previews: PreviewProvider {
    static var previews: some View {
        AlertsView()
            .environmentObject(AppViewModel())
            .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
    }
}
