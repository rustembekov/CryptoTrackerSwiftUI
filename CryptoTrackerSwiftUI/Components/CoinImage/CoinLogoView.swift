//
//  CoinLogoView.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 28.05.2024.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: CoinModel
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .foregroundColor(Color.theme.accent)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .foregroundColor(Color.theme.secondaryText)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinLogoView(coin: dev.coin)
    }
}
