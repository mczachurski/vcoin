//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import SwiftUI
import VirtualCoinKit

struct SettingsView: View {
    @EnvironmentObject private var coinsService: CoinsService
    @EnvironmentObject private var applicationStateService: ApplicationStateService
    @Environment(\.presentationMode) var presentationMode
    
    @State var matchSystem: Bool = true
    @State var isDarkMode: Bool = true
    @State private var selectedCurrency = Currencies.getDefaultCurrency()
    
    var body: some View {
        NavigationView {
            List {
                
                Section(header: Text("MAIN")) {
                    
                    Picker(selection: $selectedCurrency, label: Text("Currency")) {
                        ForEach(Currencies.allCurrenciesList, id: \.self) { currency in
                            HStack {
                                Text(currency.name)
                                    .font(.body)
                                Text("(\(currency.symbol))")
                                    .font(.footnote)
                                    .foregroundColor(.accentColor)
                            }.tag(currency)
                       }
                    }
                }
                
                Section(header: Text("OTHER")) {
                    NavigationLink(destination: ThirdPartyView()) {
                        Text("Third party")
                    }

                    HStack {
                        Text("Source code")
                        Spacer()
                        Link("GitHub",
                              destination: URL(string: "https://github.com/mczachurski/vcoin")!)
                    }

                    HStack {
                        Text("Report a bug")
                        Spacer()
                        Link("Issues on Github",
                              destination: URL(string: "https://github.com/mczachurski/vcoin/issues")!)
                    }
                    
                    HStack {
                        Text("Follow me on Twitter")
                        Spacer()
                        Link("@mczachurski",
                              destination: URL(string: "https://twitter.com/@mczachurski")!)
                    }
                    
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("2.0.0")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.saveSettings()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done").bold()
            })
        }.onAppear {
            self.loadDefaultCurrency()
        }
    }
    
    private func loadDefaultCurrency() {
        let settingsHandler = SettingsHandler()
        let defaultSettings = settingsHandler.getDefaultSettings()
        
        if defaultSettings.currency != "" {
            self.selectedCurrency = Currency(symbol: defaultSettings.currency)
        }
    }
    
    private func saveSettings() {
        let settingsHandler = SettingsHandler()
        let defaultSettings = settingsHandler.getDefaultSettings()
        defaultSettings.currency = self.selectedCurrency.symbol
        
        CoreDataHandler.shared.save()
        coinsService.loadCoins(into: applicationStateService) { _ in }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
                .preferredColorScheme(.dark)
            
            SettingsView()
                .preferredColorScheme(.light)
        }
    }
}
