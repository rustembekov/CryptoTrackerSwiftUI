//
//  CoinImageService.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 03.05.2024.
//

import Foundation
import Combine
import SwiftUI

class CoinImageService {
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instanse
    private let folderName: String = "coin_images"
    private let imageName: String
    
    init(coin : CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getUImage(imageName: imageName, folderName: folderName){
            image = savedImage
//            print("RETRIEVED")
        } else{
            downloadCoinImage()
//            print("DOWNLOADING")
        }
    }

    
    private func downloadCoinImage(){
        
        guard let url = URL(string: coin.image) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink( receiveCompletion: NetworkingManager.handleCompletion
            ,receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else {return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
