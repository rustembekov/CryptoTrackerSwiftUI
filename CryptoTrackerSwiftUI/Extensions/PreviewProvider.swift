//
//  PreviewProvider.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 28.04.2024.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview{
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() {
    }
    
    let homeVM = HomeViewModel()
    
    let stat1 = StatisticModel(title: "Market Cap", value: "$12.5Bn", percentageChange: 24.34)
    let stat2 = StatisticModel(title: "Total Volume", value: "$1.23Tr")
    let stat3 = StatisticModel(title: "Portfolio Value", value: "$50.4K", percentageChange: -12.34)
    
    let coin = CoinModel(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        currentPrice: 63196,
        marketCap: 1243901553172,
        marketCapRank: 1,
        fullyDilutedValuation: 1326586623512,
        totalVolume: 19376330158,
        high24H: 64055,
        low24H: 62528,
        priceChange24H: -671.4106159915536,
        priceChangePercentage24H: -1.05126,
        marketCapChange24H: -15453818212.822266,
        marketCapChangePercentage24H: -1.22712,
        circulatingSupply: 19691087.0,
        totalSupply: 21000000.0,
        maxSupply: 21000000.0,
        ath: 73738,
        athChangePercentage: -14.28064,
        athDate: "2024-03-14T07:10:36.635Z",
        atl: 67.81,
        atlChangePercentage: 93114.30451,
        atlDate: "2013-07-06T00:00:00.000Z",
        lastUpdated: "2024-04-27T21:19:51.884Z",
        sparklineIn7D: SparklineIn7D(price: [
            65230.14679487167,
            65011.84960433182,
            64936.27741888656,
            64735.622959073444,
            3144.1175722860658,
            3157.0807579770094,
            3139.267081384498,
            3151.5121048245724,
            3182.098833664669,
            3170.971837468052,
            3176.8831900484242,
            3178.2377690096705,
            3179.078905819649,
            3182.2316635832362,
            3171.212557764762,
            3170.357688696152,
            3171.1760926465017,
            3170.3487324514704,
            3159.610341266354,
            3146.3835240573253,
            3150.8524772981214,
            3159.987964594203,
            3138.0416839789123,
            3148.3155920187783,
            3145.4573631771596,
            3142.949774659125,
            3149.7120064902892,
            3148.478192251723,
            3156.134300067898,
            3147.13775429932,
            3154.632383947828,
            3141.672569791788,
            3147.026518355518,
            3195.7063800560295,
            3195.2286953577227,
            3226.498437992104,
            3224.2060708821327,
            3206.5031502883085,
            3205.308368806268,
            3216.013959054845,
            3212.45733059439,
            3195.1545977928185,
            3207.9606098286026,
            3193.517545404134,
            3181.5536396047532,
            3183.99477115995,
            3186.1563283533915,
            3198.4870117852174,
            3192.8885792282645,
            3191.6564131232126
        ]),
        priceChangePercentage24HInCurrency: 2.9856242544158462,
        currentHoldings: 1.5)
}



struct Previews_PreviewProvider_LibraryContent: LibraryContentProvider {
    var views: [LibraryItem] {
        LibraryItem(/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/)
    }
}
