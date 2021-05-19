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
    @EnvironmentObject var coinsService: CoinsService
    @State private var state: ViewState = .iddle
    @State private var chartData: [Double] = []

    public var chartTimeRange: ChartTimeRange
    public var coin: CoinViewModel
            
    var body: some View {
        switch state {
        case .iddle:
            Text("Iddle").onAppear {
                self.load()
            }
        case .loading:
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
        case .loaded:
            VStack {
                LightChartView(data: self.chartData,
                               type: .curved,
                               visualType: .customFilled(color: .main,
                                                         lineWidth: 2,
                                                         fillGradient: LinearGradient(
                                                            gradient: .init(colors: [.main(opacity: 0.5), .main(opacity: 0.1)]),
                                                            startPoint: .init(x: 0.5, y: 1),
                                                            endPoint: .init(x: 0.5, y: 0)
                                                         )),
                               currentValueLineType: .dash(color: .main(opacity: 0.3), lineWidth: 1, dash: [5]))
            }
        case .error(let error):
            Text("\(error.localizedDescription)")
        }
    }
    
    private func load() {
        state = .loading
        
        coinsService.loadChartData(coin: coin, chartTimeRange: chartTimeRange) { result in
            switch result {
            case .success(let chartData):
                self.chartData = chartData
                self.state = .loaded
                break;
            case .failure(let error):
                self.state = .error(error)
                break;
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChartView(chartTimeRange: .hour, coin: PreviewData.getCoinViewModel())
                .environmentObject(CoinsService.preview)
                .preferredColorScheme(.dark)

            ChartView(chartTimeRange: .hour, coin: PreviewData.getCoinViewModel())
                .environmentObject(CoinsService.preview)
                .preferredColorScheme(.light)
        }
        .previewLayout(.fixed(width: 360, height: 360))
    }
}
