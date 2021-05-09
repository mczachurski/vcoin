//
//  SettingsView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 03/05/2021.
//

import SwiftUI
import VirtualCoinKit

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State var matchSystem: Bool = true
    @State var isDarkMode: Bool = true
    @State private var selectedCurrency = Currency(id: "USD", locale: "", name: "")
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("APPERANCE")) {
                    Toggle(isOn: $matchSystem) {
                        Text("Match system")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    
                    if matchSystem == false {
                        Toggle(isOn: $isDarkMode) {
                            Text("Dark mode")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    }
                }
                
                Section(header: Text("MAIN")) {
                    
                    Picker(selection: $selectedCurrency, label: Text("Currency")) {
                        ForEach(Currencies.allCurrenciesList, id: \.self) { currency in
                            HStack {
                                Text(currency.name)
                                    .font(.body)
                                Text("(\(currency.id))")
                                    .font(.footnote)
                                    .foregroundColor(.accentColor)
                            }.tag(currency)
                       }
                    }.onChange(of: selectedCurrency, perform: { value in
                        print("selected: \(value.id)")
                    })
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
            self.selectedCurrency = Currency(id: defaultSettings.currency, locale: "", name: "")
        }
    }
    
    private func saveSettings() {
        let settingsHandler = SettingsHandler()
        let defaultSettings = settingsHandler.getDefaultSettings()
        defaultSettings.currency = self.selectedCurrency.id
        
        CoreDataHandler.shared.save()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
