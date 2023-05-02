//
//  RepositoriesStore.swift
//  MultipleRepository
//
//  Created by And Nik on 27.04.23.
//

import SwiftUI

final class RepositoriesStore: ObservableObject {
    
    var repositories: [Repository] = []
    var sortedRepositories: [Repository] = []
}
