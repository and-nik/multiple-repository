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
