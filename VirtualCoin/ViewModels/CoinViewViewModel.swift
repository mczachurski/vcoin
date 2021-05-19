//
//  CoinViewViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 16/05/2021.
//

import Foundation

public protocol CoinViewViewModelProtocol: ObservableObject {    
    var state: ViewState<[MarketViewModel]> { get set }
    var coin: CoinViewModel { get }
        
    init(coin: CoinViewModel)
    func load()
}

public class CoinViewViewModel: CoinViewViewModelProtocol {

    @Published public var state: ViewState<[MarketViewModel]> = .iddle
    public let coin: CoinViewModel
            
    required public init(coin: CoinViewModel) {
        self.coin = coin
    }
    
    public func load() {
        state = .loading
        
        ApplicationState.shared.loadData { result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.state = .loaded(ApplicationState.shared.markets ?? [])
                }
                break;
            case .failure(let error):
                self.state = .error(error)
                break;
            }
        }
    }
}

public class MockCoinViewViewModel: CoinViewViewModelProtocol {
    public typealias ChartViewViewModelProtocol = MockChartViewViewModel
    
    public var state: ViewState<[MarketViewModel]> = .loaded(PreviewData.getMarketsViewModel())
    public let coin: CoinViewModel
            
    required public init(coin: CoinViewModel) {
        self.coin = coin
    }
    
    public func load() {
    }
}
