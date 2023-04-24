//
//  NetworkManager.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import Foundation

enum NetworkErrors: Error {
    case invalidURL
    case noResponse
    case invalidDecodeData
    case unauthorized
    case unexpectedStatusCode
}

protocol NetworkManagerProtocol {
    func request<T: Decodable>(with endpoint: EndpointProtocol, responseModel: T.Type) async throws -> T
}

extension NetworkManagerProtocol {
    
    func request<T: Decodable>(with endpoint: EndpointProtocol, responseModel: T.Type) async throws -> T {
        guard let url = URL(string: endpoint.baseURL + "/" + endpoint.path) else { throw NetworkErrors.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.metod.rawValue
        if let headers = endpoint.headers {
            request.allHTTPHeaderFields = headers
        }
        if let body = endpoint.body {
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = bodyData
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkErrors.noResponse }
        print(response.statusCode)
        switch response.statusCode {
        case 200...299:
            guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else { throw NetworkErrors.invalidDecodeData }
            return decodedResponse
        case 401: throw NetworkErrors.unauthorized
        default: throw NetworkErrors.unexpectedStatusCode
        }
    }
}


















//final class NetworkManager: NetworkManagerProtocol {
//    func fetchData(from origin: DataOrigin) async throws -> [Repository] {
//        []
//    }
    

//    private let githubURL = "https://api.github.com/repositories?"
//    private let bitbucketURL = "https://api.bitbucket.org/2.0/repositories?fields=values.name,values.owner,values.description"
//
//    public func fetchData(from origin: DataOrigin) async throws -> [Repository] {
//        var url = URL(string: "")
//        switch origin {
//        case .github: url = URL(string: githubURL)
//        case .bitbucket: url = URL(string: bitbucketURL)
//        }
//        guard let url else { throw NetworkErrors.invalidURL }
//        let (data, response) = try await URLSession.shared.data(from: url)
//        //guard let HTTPResponse = response as? HTTPURLResponse else { throw NetworkErrors.invalidResponse }
//        //print(HTTPResponse.statusCode)
//        //responce handle...
//        switch origin {
//        case .bitbucket:
//            let bit = try JSONDecoder().decode(Bitbucket.self, from: data)
//            let repos = bit.repos
//            return try await repos.asyncMap {
//                let icon = try await $0.owner.links.avatar.getIconData()
//                return Repository(title: $0.title,
//                                  userIcon: icon,
//                                  description: $0.description ?? "No description",//$0.description,
//                                  dataOrigin: .bitbucket,
//                                  ownerNikname: $0.owner.name,
//                                  ownerURL: $0.owner.links.html.href,
//                                  repoURL: nil)
//            }
//        case .github:
//            var repos = [GithubData]()
//            do {
//                repos = try JSONDecoder().decode([GithubData].self, from: data)
//            } catch {
//                return []
//            }
//            return try await repos.asyncMap {
//                let icon = try await $0.owner.getIconData()
//                return Repository(title: $0.title,
//                                  userIcon: icon,
//                                  description: $0.description ?? "No description",
//                                  dataOrigin: .github,
//                                  ownerNikname: $0.owner.nikname,
//                                  ownerURL: $0.owner.url,
//                                  repoURL: $0.repoURL)
//            }
//        }
//    }
//}


//func fetchData(from origin: DataOrigin) async throws -> [Repository]
