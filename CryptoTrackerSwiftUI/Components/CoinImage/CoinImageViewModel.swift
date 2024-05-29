//
//  CoinImageModel.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 03.05.2024.
//

import Foundation
import Combine
import SwiftUI

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
  
    private var cancellables = Set<AnyCancellable>()
    private let coin: CoinModel
    private let dataService: CoinImageService

    
    init(coin : CoinModel){
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        dataService.$image
            .sink{ [weak self] (_) in
                self?.isLoading = false
            }receiveValue:{ [weak self] (returnImage) in
                self?.image = returnImage
            }
            .store(in: &cancellables)
        }
}
