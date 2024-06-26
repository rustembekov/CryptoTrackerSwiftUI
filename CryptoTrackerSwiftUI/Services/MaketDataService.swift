//
//  MaketDataService.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 25.05.2024.
//

import Foundation
import Combine

class MarketDataService {
    @Published var allData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData(){
        
        guard let url = URL(string: "https:api.coingecko.com/api/v3/global") else {return}
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)

            .sink( receiveCompletion: NetworkingManager.handleCompletion
                   ,receiveValue: { [weak self] (returnedGlobalData) in
                self?.allData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
