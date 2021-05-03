//
//  ChartView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 03/05/2021.
//

import SwiftUI
import VirtualCoinKit
import LightChart

struct ChartView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    var chartTimeRange: ChartTimeRange
    var coin: CoinViewModel
        
    var body: some View {
        VStack {            
            if let data = self.appViewModel.chartData {
                LightChartView(data: data,
                               type: .curved,
                               visualType: .customFilled(color: .main,
                                                         lineWidth: 2,
                                                         fillGradient: LinearGradient(
                                                            gradient: .init(colors: [.main(opacity: 0.5), .main(opacity: 0.1)]),
                                                            startPoint: .init(x: 0.5, y: 1),
                                                            endPoint: .init(x: 0.5, y: 0)
                                                         )),
                               currentValueLineType: .dash(color: .main(opacity: 0.3), lineWidth: 1, dash: [5]))
            } else {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
        }
        .onAppear{
            self.loadChartData()
        }
    }
    
    private func loadChartData() {
        self.appViewModel.loadChartData(coin: self.coin, chartTimeRange: self.chartTimeRange)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(chartTimeRange: .day, coin: CoinViewModel(id: "bitcoin",
                                                            rank: "1",
                                                            symbol: "BTC",
                                                            name: "Bitcoin",
                                                            priceUsd: 6929.821775,
                                                            changePercent24Hr: -0.81014))
            .previewLayout(.fixed(width: 360, height: 560))
    }
}
