//
//  RepositoriesViewModel.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import SwiftUI

protocol RepositoriesViewModelProtocol: ObservableObject {
    
    var networkManager: RepositoriesNetworkManager { get }
    func getRepo() async
    
    //error handle variable
    var isLoading: Bool { get set }
    var isReloadButtonShowing: Bool { get set }
    var isAlertShowing: Bool { get set }
    
    var loadingError: String { get set }
    
    var repositoriesStore: RepositoriesStore { get set }
    
    var filteredStrings: (title: String, nikname: String) { get set }
    var sortType: SortType { get set }
    
    func refresh()
}

final class RepositoriesViewModel: RepositoriesViewModelProtocol, ObservableObject {
    
    let networkManager: RepositoriesNetworkManager
    
    @Published var isLoading: Bool = true
    @Published var isReloadButtonShowing: Bool = false
    @Published var isAlertShowing: Bool = false
    var loadingError: String = ""
    
    var filteredStrings = (title: "", nikname: "")
    var sortType: SortType = .none
    
    var repositoriesStore: RepositoriesStore = RepositoriesStore()
    
    init(networkManager: RepositoriesNetworkManager) {
        self.networkManager = networkManager
    }
    
    public func getRepo() async {
        Task { @MainActor in
            do {
                let bitbucketRepositories = try await networkManager.getRepo(from: .bitbucket)
                let githubRepositories = try await networkManager.getRepo(from: .github)
                repositoriesStore.repositories = bitbucketRepositories + githubRepositories
                repositoriesStore.repositories.shuffle()
                repositoriesStore.sortedRepositories = repositoriesStore.repositories
                isLoading = false
                isReloadButtonShowing = false
            } catch {
                print(error)
                isLoading = false
                isReloadButtonShowing = true
                loadingError = "Some problem: " + "\(error)"
                isAlertShowing.toggle()
            }
        }
    }
    
    public func refresh() {
        Task { await getRepo() }
        sortType = .none
        filteredStrings.title = ""
        filteredStrings.nikname = ""
    }
}
