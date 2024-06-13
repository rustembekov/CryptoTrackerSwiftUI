//
//  ChartView.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 13.06.2024.
//

import SwiftUI

struct ChartView: View {
    
    let data: [Double]
    let maxY: Double
    let minY: Double
    
    let colorValidator: Color
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        self.colorValidator = ((data.last ?? 0) - (data.first ?? 0) > 0) ? Color.theme.green : Color.theme.red
    }
    //60000
    //50000
    // yAxis =( height / 60000-50000) * 100
    //
    // data = 52000
    // yRange = 52000 - 50000 = 2000
    var body: some View {
        chartView
            .frame(height: 200)
            .background(chartBackground)
            .overlay(chartYAxisValues, alignment: .leading)
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
            .stroke(colorValidator, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
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
}
