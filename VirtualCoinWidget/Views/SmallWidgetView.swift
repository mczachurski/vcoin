//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
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
                            Text("\(viewModels[index].name)")
                                .font(.caption2)
                            Text("\(viewModels[index].symbol)")
                                .foregroundColor(Color.gray)
                                .font(.caption2)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing){
                            Text("\(viewModels[index].price.toFormattedPrice(currency: currencySymbol))")
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
