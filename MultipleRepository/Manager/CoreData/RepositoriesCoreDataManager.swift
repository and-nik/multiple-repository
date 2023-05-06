//
//  RepositoriesCoreDataManager.swift
//  MultipleRepository
//
//  Created by And Nik on 06.05.23.
//

import Foundation
import CoreData

protocol RepositoriesCoreDataManagerProtocol: CoreDataManagerProtocol
where Model == Repository, CoreDataModel == RepositoryModel {
    func loadFromCoreData() -> [Repository]
    func saveToCoreData(repos: [Repository])
}

final class RepositoriesCoreDataManager: RepositoriesCoreDataManagerProtocol {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    init(persistentContainerName: String) {
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores { persistentStore, error in
            if let error { print(error) }
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        self.context = container.viewContext
    }
    
    func loadFromCoreData() -> [Repository] {
        return getData { coreDataModel in
            let origin: DataOrigin = coreDataModel.dataOrigin == "a" ? .github : .bitbucket
            return Repository(
                title: coreDataModel.title ?? "Unknowed",
                userIcon: coreDataModel.userIcon ?? Data(),
                description: coreDataModel.repoDescription ?? "No description",
                dataOrigin: origin,
                ownerNikname: coreDataModel.ownerNikname ?? "Unknowed",
                ownerURL: coreDataModel.ownerURL != nil ? URL(string: coreDataModel.ownerURL!) : nil,
                repoURL: coreDataModel.repoURL != nil ? URL(string: coreDataModel.repoURL!) : nil)
        }
    }
    
    func saveToCoreData(repos: [Repository]) {
        saveData(modelArray: repos) { repo, contex in
            let coreDataElement = RepositoryModel(context: contex)
            coreDataElement.title = repo.title
            coreDataElement.userIcon = repo.userIcon
            coreDataElement.repoDescription = repo.description
            let originString: String = repo.dataOrigin == .github ? "a" : "b"
            coreDataElement.dataOrigin = originString
            coreDataElement.ownerNikname = repo.ownerNikname ?? "Unknowed"
            coreDataElement.ownerURL = repo.ownerURL?.absoluteString
            coreDataElement.repoURL = repo.repoURL?.absoluteString
        }
    }
    
}
