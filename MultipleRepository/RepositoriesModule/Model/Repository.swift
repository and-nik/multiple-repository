//
//  Repository.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import UIKit

struct Repository {
    let title: String
    let userIcon: Data
    let description: String
    let dataOrigin: DataOrigin
    
    let ownerNikname: String?
    let ownerURL: URL?
    let repoURL: URL?
}
