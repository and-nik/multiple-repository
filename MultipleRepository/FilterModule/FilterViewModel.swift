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
    var repositoriesStore: RepositoriesStore { get }
    
    var completion: ([Repository], (title: String, nikname: String), SortType) -> Void { get set }
    func filter()
    var isFiltered: Bool { get set }
    
    var count: Int { get }
}

final class FilterViewModel: FilterViewModelProtocol {
    
    @Published var sortType: SortType = .none
    @Published var filteredStrings = (title: "", nikname: "")
    
    @Binding var isFiltered: Bool
    @Published var count: Int
    
    @ObservedObject var repositoriesStore: RepositoriesStore
    
    var completion: ([Repository], (title: String, nikname: String), SortType) -> Void
    
    init(sortType: SortType,
         filteredStrings: (title: String, nikname: String),
         isFiltered: Binding<Bool>,
         repositoriesStore: RepositoriesStore,
         completion: @escaping ([Repository], (title: String, nikname: String), SortType) -> Void) {
        self.sortType = sortType
        self._isFiltered = isFiltered
        self.filteredStrings = filteredStrings
        self.completion = completion
        self.repositoriesStore = repositoriesStore
        self.count = repositoriesStore.sortedRepositories.count
    }
    
    func filter() {
        repositoriesStore.sortedRepositories = repositoriesStore.repositories
        switch sortType {
        case .gitToBit:
            repositoriesStore.sortedRepositories = repositoriesStore.sortedRepositories.sorted { $0.dataOrigin.rawValue < $1.dataOrigin.rawValue }
        case .bitToGit:
            repositoriesStore.sortedRepositories = repositoriesStore.sortedRepositories.sorted { $0.dataOrigin.rawValue > $1.dataOrigin.rawValue }
        case .AToZ:
            repositoriesStore.sortedRepositories = repositoriesStore.sortedRepositories.sorted { $0.title < $1.title }
        case .ZToA:
            repositoriesStore.sortedRepositories = repositoriesStore.sortedRepositories.sorted { $0.title > $1.title }
        case .none: break
        }
        repositoriesStore.sortedRepositories = repositoriesStore.sortedRepositories
            .filter { filteredStrings.title != "" ? $0.title.lowercased().contains(filteredStrings.title.lowercased()) : true }
            .filter { $0.ownerNikname != nil && filteredStrings.nikname != "" ? $0.ownerNikname!.lowercased().contains(filteredStrings.nikname.lowercased()) : true }
        count = repositoriesStore.sortedRepositories.count
    }
}
