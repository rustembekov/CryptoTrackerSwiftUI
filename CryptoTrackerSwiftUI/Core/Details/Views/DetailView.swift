//
//  DetailView.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 08.06.2024.
//

import SwiftUI

struct DownloadingDetailView: View {
    @Binding var coin: CoinModel?
    var body: some View {
        if let coin = coin {
            DetailView(coin: coin)
        }
    }
}

struct DetailView: View {
    @StateObject var vm: DetailViewModel
    @State var showFullTextDescription: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing Detail View for \(coin.name)")
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20){
                    overviewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection
                }
                .padding()
            }
        }
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTraiingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView {
    private var navigationBarTraiingItems: some View {
        HStack{
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
                
        }
    }
    
    private var descriptionSection: some View {
        ZStack {
            VStack(alignment: .leading) {
                if let description = vm.descriptionCoinDetails, !description.isEmpty {
                    Text(description)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(showFullTextDescription ? nil : 3)
                }
                Button(action: {
                    withAnimation(.easeInOut) {
                        showFullTextDescription.toggle()
                    }
                }, label: {
                    Text(showFullTextDescription ? "Hide" : "Show more...")
                        .font(.caption)
                        .bold()
                        .padding(.vertical, 4)
                })
                .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .foregroundColor(Color.theme.accent)
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Settings")
            .foregroundColor(Color.theme.accent)
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: nil,
            pinnedViews: [],
            
            content: {
                ForEach(vm.overview) { stats in
                    StatisticView(stat: stats)
                }
            })
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: nil,
            pinnedViews: [],
            
            content: {
                ForEach(vm.additional) { stats in
                    StatisticView(stat: stats)
                }
            })
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteURL = vm.websiteURL,
               let url = URL(string: websiteURL) {
                Link("Website URL", destination: url)
            }
            if let redditURL = vm.redditURL,
               let url = URL(string: redditURL) {
                Link("Reddit URL", destination: url)
            }
            
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
