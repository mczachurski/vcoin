//
//  CoinView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 20/04/2021.
//

import SwiftUI
import VirtualCoinKit

struct CoinView: View {
    var coin: Coin

    var body: some View {
        Text("Coin details: \(coin.fullName ?? "")")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Edit button was tapped")
                }) {
                    Image(systemName: "globe")
                }
                
                Button(action: {
                    print("Edit button was tapped")
                }) {
                    Image(systemName: "star.fill")
                }
                
                Button(action: {
                    print("Edit button was tapped")
                }) {
                    Image(systemName: "bell.fill")
                }
            }
        }
    }
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView(coin: Coin(data: ["FullName": "Bitcoin"]))
    }
}
