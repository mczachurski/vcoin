//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import SwiftUI
import VirtualCoinKit

struct ExchangeRowView: View {
    @ObservedObject public var exchangeViewModel: ExchangeViewModel

    let onDetail: () -> Void
    
    var body: some View {
        Button(action: onDetail) {
            ZStack {
                HStack {
                    CoinImageView(coin: exchangeViewModel.coinViewModel)
                    VStack(alignment: .leading) {
                        Text("\(exchangeViewModel.coinViewModel.name)")
                            .font(.headline)
                        Text(exchangeViewModel.exchangeItem.coinSymbol)
                            .font(.subheadline)
                            .foregroundColor(.accentColor)
                        Text("\(exchangeViewModel.exchangeItem.amount.toFormattedAmount())")
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
}

struct ExchangeRowView_Previews: PreviewProvider {    
    static var previews: some View {
        Group {
            ExchangeRowView(exchangeViewModel: PreviewData.getExchangeViewModel()) {
            }
            .preferredColorScheme(.dark)
            
            ExchangeRowView(exchangeViewModel: PreviewData.getExchangeViewModel()) {
            }
            .preferredColorScheme(.light)
        }
        .previewLayout(.fixed(width: 360, height: 70))
    }
}
