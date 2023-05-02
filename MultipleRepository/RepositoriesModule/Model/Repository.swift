//
//  Repository.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import UIKit

struct Repository: Hashable {
    let title: String
    let userIcon: Data
    let description: String
    let dataOrigin: DataOrigin
    
    let ownerNikname: String?
    let ownerURL: URL?
    let repoURL: URL?
    
    init(title: String, userIcon: Data, description: String, dataOrigin: DataOrigin, ownerNikname: String?, ownerURL: URL?, repoURL: URL?) {
        self.title = title
        self.userIcon = userIcon
        self.description = description
        self.dataOrigin = dataOrigin
        self.ownerNikname = ownerNikname
        self.ownerURL = ownerURL
        self.repoURL = repoURL
    }
}
