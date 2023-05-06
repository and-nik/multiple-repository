//
//  RepositoriesNetworkManager.swift
//  MultipleRepository
//
//  Created by And Nik on 21.04.23.
//

import Foundation

protocol RepositoriesNetworkManagerProtocol: NetworkManagerProtocol {
    func getRepo(from origin: DataOrigin) async throws -> [Repository]
}

final class RepositoriesNetworkManager: RepositoriesNetworkManagerProtocol {
    
    var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }

    func getRepo(from origin: DataOrigin) async throws -> [Repository] {
        let url = try url(origin: origin)
        let urlRequest = try combineRequest(url: url, metod: .get, headers: nil, body: nil)
        let data = try await request(request: urlRequest)
        return try await decode(origin: origin, data: data)
    }
    
    func url(origin: DataOrigin) throws -> URL {
        var comp = URLComponents()
        switch origin {
        case .github:
            comp.scheme = "https"
            comp.host = "api.github.com"
            comp.path = "/repositories"
            //comp.query = ""
        case .bitbucket:
            comp.scheme = "https"
            comp.host = "api.bitbucket.org"
            comp.path = "/2.0/repositories"
            comp.query = "fields=values.name,values.owner,values.description,values.links"
            //comp.queryItems = [URLQueryItem(name: "fields", value: "values.name,values.owner,values.description")]
        }
        if comp.url == nil {
            throw NetworkErrors.invalidURL
        } else {
            return comp.url!
        }
    }
    
    func decode(origin: DataOrigin, data: Data) async throws -> [Repository] {
        switch origin {
        case .bitbucket:
            guard let bit = try? JSONDecoder().decode(Bitbucket.self, from: data) else { throw NetworkErrors.invalidDecodeData }
            let repos = bit.repos
            return try await repos.asyncMap {
                let icon = try await $0.owner.links.avatar.getIconData()
                return Repository(title: $0.title,
                                  userIcon: icon,
                                  description: $0.description ?? "No description",
                                  dataOrigin: .bitbucket,
                                  ownerNikname: $0.owner.name,
                                  ownerURL: $0.owner.links.html.href,
                                  repoURL: $0.links.html.href)
            }
        case .github:
            //guard let repos = try? JSONDecoder().decode([GithubData].self, from: data) else { throw NetworkErrors.invalidDecodeData }
            guard let repos = try? JSONDecoder().decode([GithubData].self, from: data) else { return [] }
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
