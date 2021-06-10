//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import SwiftUI
import VirtualCoinKit
import LightChart

struct ChartView: View {
    @EnvironmentObject private var applicationStateService: ApplicationStateService
    @EnvironmentObject private var coinsService: CoinsService
    
    @State private var state: ViewState = .iddle
    @State private var chartData: [Double] = []

    public var chartTimeRange: ChartTimeRange
    public var coin: CoinViewModel
    
    @Setting(\.currency) private var currencySymbol: String
            
    var body: some View {
        switch state {
        case .iddle:
            Text("").onAppear {
                self.load()
            }
        case .loading:
            LoadingView()
        case .loaded:
            ZStack(alignment: .topTrailing) {
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
                VStack {
                    self.getLabelView(value: self.getMaxValue())
                        .offset(x: -4, y: 4)
                    Spacer()
                    self.getLabelView(value: self.getMinValue())
                        .offset(x: -4, y: -4)
                }
            }
        case .error(let error):
            ErrorView(error: error)
                .padding()
        }
    }
    
    private func getLabelView(value: Double) -> some View {
        Text(value.toFormattedPrice(currency: currencySymbol))
            .font(.footnote)
            .padding(2)
            .background(Color.backgroundLabel(opacity: 0.4))
            .foregroundColor(.main)
            .cornerRadius(5)
    }
    
    private func getMaxValue() -> Double {
        return (self.chartData.max() ?? 0) / self.applicationStateService.currencyRateUsd
    }
    
    private func getMinValue() -> Double {
        return (self.chartData.min() ?? 0) / self.applicationStateService.currencyRateUsd
    }
    
    private func load() {
        state = .loading
        
        coinsService.getChartData(coin: coin, chartTimeRange: chartTimeRange) { result in
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
