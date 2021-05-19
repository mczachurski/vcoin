//
//  AlertRowView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 09/05/2021.
//

import SwiftUI
import VirtualCoinKit

struct AlertRowView: View {
    @ObservedObject public var alertViewModel: AlertViewModel
    
    @State var isEnabled: Bool = true
    
    var body: some View {
        HStack {
            CoinImageView(coin: alertViewModel.coinViewModel)
            VStack(alignment: .leading) {
                Text("\(alertViewModel.coinViewModel.name)")
                    .font(.headline)
                Text(alertViewModel.alert.coinSymbol)
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                HStack {
                    Text(alertViewModel.alert.isPriceLower ? "Lower then" : "Greather then")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Text("\(alertViewModel.alert.price.toFormattedPrice(currency: alertViewModel.alert.currency))")
                        .font(.subheadline)
                    Text(alertViewModel.alert.currency)
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing)  {
                Toggle("", isOn: $isEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .labelsHidden()
            }
        }
    }
}

struct AlertRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlertRowView(alertViewModel: PreviewData.getAlertViewModel())
                .preferredColorScheme(.dark)
            
            AlertRowView(alertViewModel: PreviewData.getAlertViewModel())
                .preferredColorScheme(.light)
        }
        .previewLayout(.fixed(width: 360, height: 70))
    }
}
