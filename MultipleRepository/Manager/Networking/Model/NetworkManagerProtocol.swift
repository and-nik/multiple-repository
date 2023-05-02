//
//  NetworkManager.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import Foundation

protocol NetworkManagerProtocol {
    var session: URLSession { get }
}

extension NetworkManagerProtocol {
    
    func combineRequest(url: URL, metod: RequestMethod, headers: [String : String]?, body: [String : String]?) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = metod.rawValue
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        if let body = body {
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = bodyData
        }
        return request
    }
    
    func request(request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkErrors.noResponse }
        switch response.statusCode {
        case 200...299: return data
        case 401: throw NetworkErrors.unauthorized
        default: return data//throw NetworkErrors.unexpectedStatusCode
        }
    }
    
}











//import Foundation
//
//final class RepositoriesNetworkManager: NetworkManagerProtocol {
//
//    func getRepo(from origin: DataOrigin) async throws -> [Repository] {
//        let repoEndpoint = RepoEndpoint(metod: .get, origin: origin)
//        switch origin {
//        case .bitbucket:
//            let bit = try await request(with: repoEndpoint, responseModel: Bitbucket.self)
//            let repos = bit.repos
//            return try await repos.asyncMap {
//                let icon = try await $0.owner.links.avatar.getIconData()
//                return Repository(title: $0.title,
//                                  userIcon: icon,
//                                  description: $0.description ?? "No description",
//                                  dataOrigin: .bitbucket,
//                                  ownerNikname: $0.owner.name,
//                                  ownerURL: $0.owner.links.html.href,
//                                  repoURL: nil)
//        }
//        case .github:
//            let repos = try await request(with: repoEndpoint, responseModel: [GithubData].self)
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
//
//        }
//    }
//
//}


//public func request<T: Decodable>(with endpoint: EndpointProtocol, responseModel: T.Type) async throws -> T {
//    let url = try combineURL(from: endpoint)
//    let request = try combineRequest(from: endpoint, url: url)
//    let (data, response) = try await URLSession.shared.data(for: request)
//    guard let response = response as? HTTPURLResponse else { throw NetworkErrors.noResponse }
//    return try handleResponse(response: response, model: responseModel, data: data)
//}
//
//private func combineURL(from components: URLComponents) throws -> URL {
//    guard let url = URL(string: endpoint.baseURL + "/" + endpoint.path) else { throw NetworkErrors.invalidURL }
//    return url
//}
//
//private func combineRequest(from endpoint: EndpointProtocol, url: URL) throws -> URLRequest {
//    var request = URLRequest(url: url)
//    request.httpMethod = endpoint.metod.rawValue
//    if let headers = endpoint.headers {
//        request.allHTTPHeaderFields = headers
//    }
//    if let body = endpoint.body {
//        let bodyData = try JSONSerialization.data(withJSONObject: body)
//        request.httpBody = bodyData
//    }
//    return request
//}
//
//private func handleResponse<T: Decodable>(response: HTTPURLResponse, model: T.Type, data: Data) throws -> T {
//    switch response.statusCode {
//    case 200...299:
//        guard let decodedResponse = try? JSONDecoder().decode(model, from: data) else { throw NetworkErrors.invalidDecodeData }
//        return decodedResponse
//    case 401: throw NetworkErrors.unauthorized
//    default: throw NetworkErrors.unexpectedStatusCode
//    }
//}


//let urls = URLSession.shared
//
//init(urlSession: URLSession) {
//
//}
//
//
//
//
//
//
//func doThings() {
//    (0...100).compactMap { (0...100).randomElement() }.filter { $0 > 50 }.count
//}


//decode data <- data
//session.data <- request <- session
//request <- url
//url <- url comp




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
