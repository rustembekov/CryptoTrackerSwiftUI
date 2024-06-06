//
//  RootViewModel.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 23.04.2024.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText = ""
    @Published var statistics: [StatisticModel] = []
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioService = PortfolioService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        self.addSubscribers()
    }
    
    func addSubscribers(){
        coinDataService.$allCoins
            .sink{ [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                print(returnedCoins)
            }.store(in: &cancellables)
        
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .combineLatest(coinDataService.$allCoins)
            .map(filteredCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
            
        marketDataService.$allData
            .map(mapMarketDataGlobal)
            .sink { [weak self] (returnedStatistics) in
                self?.statistics = returnedStatistics
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioService.$storedEntities)
            .map{(coinModels, portfolioEntities) -> [CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else{
                            return nil}
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnedCoins) in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
            
    }
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func filteredCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins }
        let lowercasedValue = text.lowercased()
        
        return coins.filter{ (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedValue) || coin.id.lowercased().contains(lowercasedValue) || coin.symbol.lowercased().contains(lowercasedValue)
        }
    }
    
    private func mapMarketDataGlobal(marketDataModel: MarketDataModel?) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cup", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
}
