//
//  HomeStatsView.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 22.05.2024.
//

import SwiftUI

struct HomeStatsView: View {
   
    @Binding var showPortFolio: Bool
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        HStack {
            ForEach(vm.statistics){
                stat in StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortFolio ? .trailing : .leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortFolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
