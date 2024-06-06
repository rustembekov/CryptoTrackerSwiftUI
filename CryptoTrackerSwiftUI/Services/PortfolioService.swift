//
//  PortfolioSerives.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 05.06.2024.
//

import Foundation
import CoreData

class PortfolioService{
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var storedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error)  in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getPortfolio()
        }
    }
    
    
    //MARK: PUBLIC
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        if let existingEntity = storedEntities.first(where: {$0.coinID == coin.id}){
            if amount > 0 {
                update(entity: existingEntity, amount: amount)
            }else {
                delete(entityToDelete: existingEntity)
            }
        }
        else {
            add(coin: coin, amount: amount)
        }
    }
    
    //MARK: PRIVATE
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            storedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities! \(error)")
        }
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.amount = amount
        entity.coinID = coin.id
        applyChanges()
    }
    
    private func delete(entityToDelete: PortfolioEntity){
        container.viewContext.delete(entityToDelete)
        applyChanges()
    }
    
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving Core Data! \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
}
