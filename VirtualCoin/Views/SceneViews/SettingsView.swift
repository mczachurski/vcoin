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
    
    @State var username: String = ""
    @State var matchSystem: Bool = true
    @State var isDarkMode: Bool = true
    @State private var selectedCurrency = Currency(code: "PLN", locale: "", name: "")
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("APPERANCE")) {
                    Toggle(isOn: $matchSystem) {
                        Text("Match system")
                    }
                    
                    Toggle(isOn: $isDarkMode) {
                        Text("Dark mode")
                    }
                }
                
                Section(header: Text("MAIN")) {
                    
                    Picker(selection: $selectedCurrency, label: Text("Currency")) {
                        ForEach(Currencies.allCurrenciesList, id: \.self) { currency in
                            VStack(alignment: .leading) {
                                Text(currency.name)
                                    .font(.body)
                                Text(currency.code)
                                    .font(.footnote)
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
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done").bold()
                })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
