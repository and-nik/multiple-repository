//
//  FilterViewModel.swift
//  MultipleRepository
//
//  Created by And Nik on 22.04.23.
//

import SwiftUI

protocol FilterViewModelProtocol: ObservableObject {
    var sortType: SortType { get set }
    var filteredStrings: (title: String, nikname: String) { get set }
    var repositories: [Repository] { get set }
    var allRepositories: [Repository] { get set }
    var completion: ([Repository], (title: String, nikname: String), SortType) -> Void { get set }
    func filter()
    var isFiltered: Bool { get set }
}

final class FilterViewModel: FilterViewModelProtocol {
    
    @Published var sortType: SortType = .none
    @Published var filteredStrings = (title: "", nikname: "")
    
    @Published var repositories: [Repository]
    var allRepositories: [Repository]
    @Binding var isFiltered: Bool
    
    var completion: ([Repository], (title: String, nikname: String), SortType) -> Void
    
    init(repositories: [Repository],
         allRepositories: [Repository],
         sortType: SortType,
         filteredStrings: (title: String, nikname: String),
         isFiltered: Binding<Bool>,
         completion: @escaping ([Repository], (title: String, nikname: String), SortType) -> Void) {
        self.repositories = repositories
        self.allRepositories = allRepositories
        self.sortType = sortType
        self._isFiltered = isFiltered
        self.filteredStrings = filteredStrings
        self.completion = completion
    }
    
    func filter() {
        repositories = allRepositories
        switch sortType {
        case .gitToBit:
            repositories = repositories.sorted { $0.dataOrigin.rawValue < $1.dataOrigin.rawValue }
        case .bitToGit:
            repositories = repositories.sorted { $0.dataOrigin.rawValue > $1.dataOrigin.rawValue }
        case .AToZ:
            repositories = repositories.sorted { $0.title < $1.title }
        case .ZToA:
            repositories = repositories.sorted { $0.title > $1.title }
        case .none: break
        }
        repositories = repositories
            .filter { filteredStrings.title != "" ? $0.title.lowercased().contains(filteredStrings.title.lowercased()) : true }
            .filter { $0.ownerNikname != nil && filteredStrings.nikname != "" ? $0.ownerNikname!.lowercased().contains(filteredStrings.nikname.lowercased()) : true }
//        completion(repositories, filteredStrings, sortType)
    }
}


//@State private var sortType: SortType = .none
//@State private var filterType: FilterType = .none
//
//@State private var filterRepoString: String = ""
//@State private var filterNiknameString: String = ""
//
//@State var repositories: [Repository]
//var completion: ([Repository]) -> Void
