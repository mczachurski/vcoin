//
//  ExchangeRowView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 06/05/2021.
//

import SwiftUI
import VirtualCoinKit

struct ExchangeRowView: View {
    @ObservedObject public var exchangeViewModel: ExchangeViewModel

    var body: some View {
        ZStack {
            HStack {
                CoinImageView(coin: exchangeViewModel.coinViewModel)
                VStack(alignment: .leading) {
                    Text("\(exchangeViewModel.coinViewModel.name)")
                        .font(.headline)
                    Text(exchangeViewModel.exchangeItem.coinSymbol)
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                    Text("\(exchangeViewModel.exchangeItem.amount)")
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing)  {
                    Text("\(exchangeViewModel.currency.name)")
                        .font(.headline)
                    Text(exchangeViewModel.exchangeItem.currency)
                        .font(.subheadline)
                        .foregroundColor(.accentColor)                    
                    Text(exchangeViewModel.price.toFormattedPrice(currency: exchangeViewModel.exchangeItem.currency))
                        .font(.subheadline)
                }
            }
            HStack {
                Spacer()
                Image(systemName: "arrow.left.arrow.right")
                Spacer()
            }
        }
    }
}

struct ExchangeRowView_Previews: PreviewProvider {    
    static var previews: some View {
        Group {
            ExchangeRowView(exchangeViewModel: PreviewData.getExchangeViewModel())
                .preferredColorScheme(.dark)
            
            ExchangeRowView(exchangeViewModel: PreviewData.getExchangeViewModel())
                .preferredColorScheme(.light)
        }
        .previewLayout(.fixed(width: 360, height: 70))
    }
}
