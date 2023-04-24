//
//  RepositoriesViewModel.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import SwiftUI

protocol RepositoriesViewModelProtocol: ObservableObject {
    
    var repositories: [Repository] { get set }
    var networkManager: NetworkManagerProtocol { get }
    func getRepo() async
    func getRepositoriesCells() -> [RepositoryCell]
    
    //error handle variable
    var isLoading: Bool { get set }
    var isReloadButtonShowing: Bool { get set }
    
    //filter variable
    var allRepositories: [Repository] { get set }
    var filteredStrings: (title: String, nikname: String) { get set }
    var sortType: SortType { get set }
    func refresh()
}

final class RepositoriesViewModel: RepositoriesViewModelProtocol, ObservableObject {
    
    @Published public var repositories = [Repository]()
    let networkManager: NetworkManagerProtocol
    @Published var isLoading: Bool = true
    @Published var isReloadButtonShowing: Bool = false
    
    var filteredStrings = (title: "", nikname: "")
    var sortType: SortType = .none
    lazy var allRepositories = repositories
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        Task {
            await getRepo()
        }
    }
    
    public func getRepo() async {
        Task { @MainActor in
            do {
                guard let network = networkManager as? RepositoriesNetworkManager else { return }
                let bitbucketRepositories = try await network.getRepo(from: .bitbucket)
                let githubRepositories = try await network.getRepo(from: .github)
                repositories = bitbucketRepositories + githubRepositories
                repositories.shuffle()
                isLoading = false
                isReloadButtonShowing = false
            } catch {
                print(error)
                isLoading = false
                isReloadButtonShowing = true
            }
        }
    }
    
    public func getRepositoriesCells() -> [RepositoryCell] {
        repositories.map { RepositoryCell(repo: $0) }
    }
    
    public func refresh() {
        Task {
            await getRepo()
        }
        sortType = .none
        filteredStrings.title = ""
        filteredStrings.nikname = ""
    }
}
