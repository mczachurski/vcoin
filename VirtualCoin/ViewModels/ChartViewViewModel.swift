//
//  CoinViewViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 18/05/2021.
//

import Foundation
import VirtualCoinKit

public protocol ChartViewViewModelProtocol: ObservableObject {
    var state: ViewState<[Double]> { get set}
    var chartTimeRange: ChartTimeRange { get set }
    var coin: CoinViewModel { get set }

    init(chartTimeRange: ChartTimeRange, coin: CoinViewModel)
    func load()
}

public class ChartViewViewModel: ChartViewViewModelProtocol {

    @Published public var state: ViewState<[Double]> = .iddle

    public var chartTimeRange: ChartTimeRange
    public var coin: CoinViewModel
    
    required public init(chartTimeRange: ChartTimeRange, coin: CoinViewModel) {
        self.chartTimeRange = chartTimeRange
        self.coin = coin
    }
    
    public func load() {
        state = .loading
        
        ApplicationState.shared.loadChartData(coin: coin, chartTimeRange: chartTimeRange) { result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.state = .loaded(ApplicationState.shared.chartData ?? [])
                }
                break;
            case .failure(let error):
                self.state = .error(error)
                break;
            }
        }
    }
}

public class MockChartViewViewModel: ChartViewViewModelProtocol {
    public var state: ViewState<[Double]> = .loaded([3, 4, 3, 42, 23, 32, 32, 34, 43, 54, 34, 54, 12])
    
    public var chartTimeRange: ChartTimeRange
    public var coin: CoinViewModel
    
    required public init(chartTimeRange: ChartTimeRange, coin: CoinViewModel) {
        self.chartTimeRange = chartTimeRange
        self.coin = coin
    }
    
    public func load() {
    }
}
