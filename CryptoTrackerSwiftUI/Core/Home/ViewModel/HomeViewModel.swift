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
    @Published var isLoading: Bool = false
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
            .combineLatest($portfolioCoins)
            .map(mapMarketDataGlobal)
            .sink { [weak self] (returnedStatistics) in
                self?.statistics = returnedStatistics
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioService.$storedEntities)
            .map(mapAllDataCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
            
    }
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        marketDataService.getData()
        coinDataService.getCoins()
    }
    
    private func filteredCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins }
        let lowercasedValue = text.lowercased()
        
        return coins.filter{ (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedValue) || coin.id.lowercased().contains(lowercasedValue) || coin.symbol.lowercased().contains(lowercasedValue)
        }
    }
    private func mapAllDataCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else{
                    return nil}
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapMarketDataGlobal(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        let portfolioValue =
            portfolioCoins
            .map(\.currentHoldingsValue)
            .reduce(0, +)
        
        let previousValue =
            portfolioCoins
            .map{(coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentValue = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + percentValue)
                return previousValue
            }
            .reduce(0, +)
        let percentValue = ((portfolioValue - previousValue) / previousValue) * 100
        
        let marketCap = StatisticModel(title: "Market Cup", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentValue)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
}
