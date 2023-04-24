//
//  RepositoriesNetworkManager.swift
//  MultipleRepository
//
//  Created by And Nik on 21.04.23.
//

import Foundation

final class RepositoriesNetworkManager: NetworkManagerProtocol {
    
    func getRepo(from origin: DataOrigin) async throws -> [Repository] {
        let repoEndpoint = RepoEndpoint(metod: .get, origin: origin)
        switch origin {
        case .bitbucket:
            let bit = try await request(with: repoEndpoint, responseModel: Bitbucket.self)
            let repos = bit.repos
            return try await repos.asyncMap {
                let icon = try await $0.owner.links.avatar.getIconData()
                return Repository(title: $0.title,
                                  userIcon: icon,
                                  description: $0.description ?? "No description",
                                  dataOrigin: .bitbucket,
                                  ownerNikname: $0.owner.name,
                                  ownerURL: $0.owner.links.html.href,
                                  repoURL: nil)
        }
        case .github:
            let repos = try await request(with: repoEndpoint, responseModel: [GithubData].self)
            return try await repos.asyncMap {
                let icon = try await $0.owner.getIconData()
                return Repository(title: $0.title,
                                  userIcon: icon,
                                  description: $0.description ?? "No description",
                                  dataOrigin: .github,
                                  ownerNikname: $0.owner.nikname,
                                  ownerURL: $0.owner.url,
                                  repoURL: $0.repoURL)
            }
        
        }
    }
    
    
    
}
