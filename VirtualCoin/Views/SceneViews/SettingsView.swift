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
    @State var isDarkMode: Bool = true
    @State private var previewIndex = 0

    var previewOptions = Currencies.allCurrenciesList.map { currency in
        currency.name
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("MAIN")) {
                    Picker(selection: $previewIndex, label: Text("Currency")) {
                        ForEach(0 ..< previewOptions.count) {
                            Text(self.previewOptions[$0])
                        }
                    }
                    Toggle(isOn: $isDarkMode) {
                        Text("Dark mode")
                    }
                }
                
                Section(header: Text("OTHER")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("2.2.1")
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
