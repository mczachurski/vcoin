//
//  VirtualCoinWidget.swift
//  VirtualCoinWidget
//
//  Created by Marcin Czachurski on 06/06/2021.
//

import WidgetKit
import SwiftUI
import Intents
import VirtualCoinKit
import LightChart

struct PreviewData {
    
    static func getCoinsViewModel() -> [CoinViewModel] {
        return [
            CoinViewModel(id: "bitcoin", rank: 1, symbol: "BTC", name: "Bitcoin", priceUsd: 36135.11, changePercent24Hr: -4.72, price: 36135.11),
            CoinViewModel(id: "ethereum", rank: 2, symbol: "ETH", name: "Ethereum", priceUsd: 2662.72, changePercent24Hr: -4.43, price: 2662.72),
            CoinViewModel(id: "dogecoin", rank: 3, symbol: "DOGE", name: "Dogecoin", priceUsd: 0.37526429, changePercent24Hr: -5.18, price: 0.37526429),
            CoinViewModel(id: "cardano", rank: 4, symbol: "USDT", name: "Cardano", priceUsd: 1.69, changePercent24Hr: -5.18, price: 1.69),
            CoinViewModel(id: "tether", rank: 5, symbol: "USDT", name: "Tether", priceUsd: 1.00, changePercent24Hr: 0.03, price: 1.00),
            CoinViewModel(id: "xrp", rank: 6, symbol: "XRP", name: "XRP", priceUsd: 0.94153174, changePercent24Hr: -5.35, price: 0.94153174)
        ]
    }
    
    static func getChartData() -> [Double] {
        return [34, 34, 23, 34, 45, 65, 34, 32, 23, 33, 65, 57, 65, 34, 65, 67]
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), coins: PreviewData.getCoinsViewModel())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry: SimpleEntry

        if context.isPreview {
            entry = SimpleEntry(date: Date(), coins: PreviewData.getCoinsViewModel())
        } else {
            entry = SimpleEntry(date: Date(), coins: PreviewData.getCoinsViewModel())
        }
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, coins: PreviewData.getCoinsViewModel())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CoinViewModel: Identifiable, Hashable {
    let id: String
    let rank: Int
    let symbol: String
    let name: String
    let priceUsd: Double
    let changePercent24Hr: Double
    let price: Double
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let coins: [CoinViewModel]
}

struct SmallWidgetView: View {
    var coins: [CoinViewModel]
    
    @Setting(\.currency) private var currencySymbol: String
    
    var body: some View {
        VStack {
            ForEach(coins.prefix(3).indices, id: \.self) { index in
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(coins[index].symbol)")
                                .foregroundColor(Color.main)
                                .font(.footnote)
                            Text("\(coins[index].name)")
                                .font(.footnote)
                        }
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("\(coins[index].priceUsd.toFormattedPrice(currency: currencySymbol))")
                                .font(.footnote)
                            Text("\(coins[index].changePercent24Hr.toFormattedPercent())")
                                .foregroundColor(coins[index].changePercent24Hr > 0 ?.greenPastel : .redPastel)
                                .font(.footnote)
                        }
                    }
                    
                    if index + 1 < (coins.capacity > 3 ? 3 : coins.capacity) {
                        Divider()
                    }
                }
            }
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }
}

struct MediumWidgetView: View {
    var coins: [CoinViewModel]
    
    @Setting(\.currency) private var currencySymbol: String

    var body: some View {
        VStack {
            ForEach(coins.prefix(3).indices, id: \.self) { index in
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(coins[index].symbol)")
                                .foregroundColor(Color.main)
                                .font(.footnote)
                            Text("\(coins[index].name)")
                                .font(.footnote)
                        }
                        Spacer()
                        
                        LightChartView(data: PreviewData.getChartData(),
                                       type: .curved,
                                       visualType: .customFilled(color: .main,
                                                                 lineWidth: 2,
                                                                 fillGradient: LinearGradient(
                                                                    gradient: .init(colors: [.main(opacity: 0.5), .main(opacity: 0.1)]),
                                                                    startPoint: .init(x: 0.5, y: 1),
                                                                    endPoint: .init(x: 0.5, y: 0)
                                                                 )))
                            .frame(maxWidth: 80, maxHeight: .infinity)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                        
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("\(coins[index].priceUsd.toFormattedPrice(currency: currencySymbol))")
                                    .font(.footnote)
                                Text("\(coins[index].changePercent24Hr.toFormattedPercent())")
                                    .foregroundColor(coins[index].changePercent24Hr > 0 ?.greenPastel : .redPastel)
                                    .font(.footnote)
                            }
                        }
                        .frame(minWidth: 100, maxWidth: 100)
                    }
                
                    if index + 1 < (coins.capacity > 3 ? 3 : coins.capacity) {
                        Divider()
                    }
                }
            }
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }
}

struct LargeWidgetView: View {
    var coins: [CoinViewModel]
    
    @Setting(\.currency) private var currencySymbol: String

    var body: some View {
        VStack {
            ForEach(coins.prefix(6).indices, id: \.self) { index in
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(coins[index].symbol)")
                                .foregroundColor(Color.main)
                                .font(.caption2)
                            Text("\(coins[index].name)")
                                .font(.footnote)
                        }
                        Spacer()
                        
                        LightChartView(data: PreviewData.getChartData(),
                                       type: .curved,
                                       visualType: .customFilled(color: .main,
                                                                 lineWidth: 2,
                                                                 fillGradient: LinearGradient(
                                                                    gradient: .init(colors: [.main(opacity: 0.5), .main(opacity: 0.1)]),
                                                                    startPoint: .init(x: 0.5, y: 1),
                                                                    endPoint: .init(x: 0.5, y: 0)
                                                                 )))
                            .frame(maxWidth: 80, maxHeight: .infinity)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                        
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("\(coins[index].priceUsd.toFormattedPrice(currency: currencySymbol))")
                                    .font(.footnote)
                                Text("\(coins[index].changePercent24Hr.toFormattedPercent())")
                                    .foregroundColor(coins[index].changePercent24Hr > 0 ?.greenPastel : .redPastel)
                                    .font(.footnote)
                            }
                        }
                        .frame(minWidth: 100, maxWidth: 100)
                    }
                    
                    if index + 1 < (coins.capacity > 6 ? 6 : coins.capacity) {
                        Divider()
                    }
                }
            }
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }
}

struct VirtualCoinWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily

    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: SmallWidgetView(coins: entry.coins)
        case .systemMedium: MediumWidgetView(coins: entry.coins)
        case .systemLarge: LargeWidgetView(coins: entry.coins)
        default: Text("Define favourites")
        }
    }
}

@main
struct VirtualCoinWidget: Widget {
    let kind: String = "VirtualCoinWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            VirtualCoinWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Virtual coin")
        .description("Shows coin prices")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct VirtualCoinWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VirtualCoinWidgetEntryView(entry: SimpleEntry(date: Date(), coins: PreviewData.getCoinsViewModel()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            VirtualCoinWidgetEntryView(entry: SimpleEntry(date: Date(), coins: PreviewData.getCoinsViewModel()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            VirtualCoinWidgetEntryView(entry: SimpleEntry(date: Date(), coins: PreviewData.getCoinsViewModel()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
