//
//  CoinsViewViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 16/05/2021.
//

import Foundation

public protocol CoinsViewViewModelProtocol: ObservableObject, Initializable {
    var state: ViewState<[CoinViewModel]> { get set}
    func load()
}

public class CoinsViewViewModel: CoinsViewViewModelProtocol {
    @Published public var state: ViewState<[CoinViewModel]> = .iddle
        
    required public init() {
    }
    
    public func load() {
        state = .loading
        
        ApplicationState.shared.loadData { result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.state = .loaded(ApplicationState.shared.coins ?? [])
                }
                break;
            case .failure(let error):
                self.state = .error(error)
                break;
            }
        }
    }
}

public class MockCoinsViewViewModel: CoinsViewViewModelProtocol {
    public var state: ViewState<[CoinViewModel]> = .loaded(PreviewData.getCoinsViewModel())
    
    required public init() {
    }
    
    public func load() {
    }
}
