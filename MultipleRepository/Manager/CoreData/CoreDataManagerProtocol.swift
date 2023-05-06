//
//  CoreDataManagerProtocol.swift
//  MultipleRepository
//
//  Created by And Nik on 05.05.23.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    associatedtype Model: Hashable
    associatedtype CoreDataModel: NSManagedObject
    
    var context: NSManagedObjectContext { get set }
    func getData(transform: (CoreDataModel) -> Model) -> [Model]
    func saveData(modelArray: [Model], transform: (Model, NSManagedObjectContext) -> Void)
}

extension CoreDataManagerProtocol {
    
    func saveContex() {
        if context.hasChanges {
            do { try context.save() }
            catch { print(error) }
        }
    }
    
    func getData(transform: (CoreDataModel) -> Model) -> [Model] {
        do {
            let materials = try context.fetch(CoreDataModel.fetchRequest())
            return materials.map { result in
                transform(result as! CoreDataModel)//this will be always not optional
            }
        } catch {
            print(error)
            return []
        }
    }
    
    func saveData(modelArray: [Model], transform: (Model, NSManagedObjectContext) -> Void) {
        modelArray.forEach { model in
            transform(model, context)
            saveContex()
        }
    }
}
