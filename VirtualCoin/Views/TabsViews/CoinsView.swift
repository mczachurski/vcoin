//
//  ContentView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 17/04/2021.
//

import SwiftUI
import CoreData
import VirtualCoinKit

struct CoinsView<VM, CoinVM, ChartVM>: View where VM: CoinsViewViewModelProtocol, CoinVM: CoinViewViewModelProtocol, ChartVM: ChartViewViewModelProtocol {
    @ObservedObject var viewModel: VM

    @ObservedObject var searchBar: SearchBar = SearchBar()
    @State private var showingSettingsView = false
    
    var body: some View {
        switch viewModel.state {
        case .iddle:
            Text("Iddle").onAppear {
                viewModel.load()
            }
        case .loading:
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
            .navigationTitle("All currencies")
        case .loaded(let coins):
            List {
                ForEach(coins.filter {
                    searchBar.text.isEmpty || $0.name.localizedStandardContains(searchBar.text)
                }) { coin in
                    NavigationLink(destination: CoinView<CoinVM, ChartVM>(viewModel: CoinVM.init(coin: coin))) {
                        CoinRowView(coin: coin)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("All currencies")
            .add(self.searchBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingSettingsView.toggle()
                    }) {
                        Image(systemName: "switch.2")
                    }
                }
            }
            .sheet(isPresented: $showingSettingsView) {
                SettingsView()
            }
        case .error(let error):
            Text("\(error.localizedDescription)")
        }
    }
}

struct CoinsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CoinsView<MockCoinsViewViewModel, MockCoinViewViewModel, MockChartViewViewModel>(viewModel: MockCoinsViewViewModel())
            }
            .preferredColorScheme(.dark)
            
            NavigationView {
                CoinsView<MockCoinsViewViewModel, MockCoinViewViewModel, MockChartViewViewModel>(viewModel: MockCoinsViewViewModel())
            }
            .preferredColorScheme(.light)
        }
    }
}
