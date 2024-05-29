//
//  LocalFileManager.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 06.05.2024.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instanse = LocalFileManager()
    private init(){}
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard
            let data = image.pngData(),
            let url = getURLImage(imageName: imageName, folderName: folderName)
        else {return}
        
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving data. \(error)" )
        }
    }
    
    func getUImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard
            let url = getURLFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    private func getURLFolder(folderName: String) -> URL? {
        guard
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLImage(imageName: String, folderName: String) -> URL? {
        guard
            let url = getURLFolder(folderName: folderName) else{
            return nil
        }
        return url.appendingPathComponent(imageName + ".png")
    }
    
    
    
}
