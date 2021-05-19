//
//  ChartView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 03/05/2021.
//

import SwiftUI
import VirtualCoinKit
import LightChart

struct ChartView<VM>: View where VM: ChartViewViewModelProtocol {
    @ObservedObject var viewModel: VM
            
    var body: some View {
        switch viewModel.state {
        case .iddle:
            Text("Iddle").onAppear {
                viewModel.load()
            }
        case .loading:
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
        case .loaded(let chartData):
            VStack {
                LightChartView(data: chartData,
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
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChartView(viewModel: MockChartViewViewModel(chartTimeRange: .hour, coin: PreviewData.getCoinViewModel()))
                .preferredColorScheme(.dark)

            ChartView(viewModel: MockChartViewViewModel(chartTimeRange: .hour, coin: PreviewData.getCoinViewModel()))
                .preferredColorScheme(.light)
        }
        .previewLayout(.fixed(width: 360, height: 360))
    }
}
