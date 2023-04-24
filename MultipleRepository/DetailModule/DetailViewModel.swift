//
//  DetailViewModel.swift
//  MultipleRepository
//
//  Created by And Nik on 21.04.23.
//

import Foundation

protocol DetailViewModelProtocol: ObservableObject {
    var repo: Repository { get }
}

final class DetailViewModel: DetailViewModelProtocol {
    
    let repo: Repository
    
    init(repo: Repository) {
        self.repo = repo
    }
}
