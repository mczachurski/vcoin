//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import SwiftUI
import VirtualCoinKit

struct AlertRowView: View {
    @ObservedObject public var alertViewModel: AlertViewModel
    
    @State var isEnabled: Bool = true
    let onDetail: () -> Void
    
    var body: some View {
        Button(action: onDetail) {
            HStack {                
                CoinImageView(coin: alertViewModel.coinViewModel)
                VStack(alignment: .leading) {
                    Text("\(alertViewModel.coinViewModel.name)")
                        .font(.headline)
                    Text(alertViewModel.alert.coinSymbol)
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                    HStack {
                        Text(alertViewModel.alert.isPriceLower ? "Lower than" : "Greather than")
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
}

struct AlertRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlertRowView(alertViewModel: PreviewData.getAlertViewModel()) {
            }
            .preferredColorScheme(.dark)
            
            AlertRowView(alertViewModel: PreviewData.getAlertViewModel()) {
            }
            .preferredColorScheme(.light)
        }
        .previewLayout(.fixed(width: 360, height: 70))
    }
}
