//
//  RepositoryModel+CoreDataProperties.swift
//  MultipleRepository
//
//  Created by And Nik on 05.05.23.
//
//

import Foundation
import CoreData


extension RepositoryModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepositoryModel> {
        return NSFetchRequest<RepositoryModel>(entityName: "RepositoryModel")
    }

    @NSManaged public var userIcon: Data?
    @NSManaged public var title: String?
    @NSManaged public var repoDescription: String?
    @NSManaged public var dataOrigin: String?
    @NSManaged public var ownerNikname: String?
    @NSManaged public var ownerURL: String?
    @NSManaged public var repoURL: String?

}

extension RepositoryModel : Identifiable {

}
