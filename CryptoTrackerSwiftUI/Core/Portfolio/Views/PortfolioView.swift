//
//  PortfolioView.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 27.05.2024.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel?
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView(){
            ScrollView(){
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .background{
                Color.theme.background
                    .ignoresSafeArea()
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    XMarkButton(dismiss: _dismiss)
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing){
                    trailingNavBarButton
                }
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
    }
    
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    private var coinLogoList: some View{
        ScrollView(.horizontal ,showsIndicators: false, content: {
            LazyHStack(spacing: 10){
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins){
                 coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .onTapGesture {
                            selectedCoin = coin
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(coin.id == selectedCoin?.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        })
    }
    private var portfolioInputSection: some View{
        VStack(spacing: 20){
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: Binding(
                    get: { self.quantityText },
                    set: { newValue in
                        var filtered = newValue.filter { "0123456789.".contains($0) }
                        let decimalCount = filtered.filter { $0 == "." }.count
                        
                        if decimalCount > 1 {
                            filtered = String(filtered.dropLast())
                        }
                        
                        self.quantityText = filtered
                    }
                ))
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getAccurate().asCurrencyWith2Decimals())
            }
        }
        .animation(.none, value: UUID())
        .padding()
        .font(.headline)
    }
    
    private func updateSelectedCoin(coin: CoinModel){
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else{
            quantityText = ""
        }
    }
    
    private func getAccurate() -> Double {
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    private var trailingNavBarButton: some View {
        HStack(spacing: 10){
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity(selectedCoin != nil && Double(quantityText) != selectedCoin?.currentHoldings ? 1 : 0)
        }
        .font(.headline)
    }
    private func saveButtonPressed(){
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
            else { return}
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn){
            showCheckMark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            withAnimation(.easeOut){
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
}
    
