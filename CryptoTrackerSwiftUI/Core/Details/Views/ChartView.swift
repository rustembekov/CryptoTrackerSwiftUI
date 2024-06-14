//
//  ChartView.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 13.06.2024.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    
    private let startingDate: Date
    private let endingDate: Date
    private let colorValidator: Color
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        self.colorValidator = ((data.last ?? 0) - (data.first ?? 0) > 0) ? Color.theme.green : Color.theme.red
        self.endingDate = Date(coinDateParameter: coin.lastUpdated ?? "")
        self.startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    //60000
    //50000
    // yAxis =( height / 60000-50000) * 100
    //
    // data = 52000
    // yRange = 52000 - 50000 = 2000
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartYAxisValues.padding(.horizontal, 4), alignment: .leading)
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)){
                    percentage = 1.0
                }
            }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChartView(coin: dev.coin)

        }
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xAxis = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    let yRangeAxis = maxY - minY
                    let yAxis = (1 - CGFloat((data[index] - minY) / yRangeAxis)) * geometry.size.height
                    if index == 0 {
                        path.move(to: CGPoint(x: xAxis, y: yAxis))
                    }
                    path.addLine(to: CGPoint(x: xAxis, y: yAxis))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(colorValidator, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: colorValidator, radius: 10, x: 0.0, y: 10)
            .shadow(color: colorValidator.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: colorValidator.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: colorValidator.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }
    }
    
    private var chartBackground: some View {
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxisValues: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY - minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.formatterDateToString())
            Spacer()
            Text(endingDate.formatterDateToString())
        }
    }
}
