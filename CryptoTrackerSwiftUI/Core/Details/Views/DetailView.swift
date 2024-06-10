//
//  DetailView.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 08.06.2024.
//

import SwiftUI

struct DetailView: View {
    @Binding var coin: CoinModel?
    
    init(coin: Binding<CoinModel?>) {
        self._coin = coin
        print("Initializing Detail View for \(coin.wrappedValue?.name)")
    }
    var body: some View {
        Text(coin?.name ?? "")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: .constant(dev.coin))
    }
}
