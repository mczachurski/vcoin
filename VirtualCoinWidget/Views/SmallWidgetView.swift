//
//  SmallWidgetView.swift
//  VirtualCoinWidgetExtension
//
//  Created by Marcin Czachurski on 07/06/2021.
//

import WidgetKit
import SwiftUI
import VirtualCoinKit

struct SmallWidgetView: View {
    var viewModels: [WidgetViewModel]
    
    @Setting(\.currency) private var currencySymbol: String
    
    var body: some View {
        VStack {
            ForEach(viewModels.prefix(3).indices, id: \.self) { index in
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(viewModels[index].symbol)")
                                .foregroundColor(Color.main)
                                .font(.caption2)
                            Text("\(viewModels[index].name)")
                                .font(.caption2)
                        }
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("\(viewModels[index].priceUsd.toFormattedPrice(currency: currencySymbol))")
                                .font(.caption2)
                            Text("\(viewModels[index].changePercent24Hr.toFormattedPercent())")
                                .foregroundColor(viewModels[index].changePercent24Hr > 0 ?.greenPastel : .redPastel)
                                .font(.caption2)
                        }
                    }
                    
                    if index + 1 < (viewModels.capacity > 3 ? 3 : viewModels.capacity) {
                        Divider()
                    }
                }
            }
        }
        .padding()
    }
}

struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VirtualCoinWidgetEntryView(entry: WidgetEntry(date: Date(), viewModels: PreviewData.getWidgetViewModels()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.colorScheme, .light)
        }
    }
}
