//
//  RepoEndpoint.swift
//  MultipleRepository
//
//  Created by And Nik on 22.04.23.
//

import Foundation

struct RepoEndpoint: EndpointProtocol {
    var baseURL: String {
        switch origin {
        case .github: return "https://api.github.com"
        case .bitbucket: return "https://api.bitbucket.org"
        }
    }
    
    var path: String {
        switch origin {
        case .github: return "repositories?"
        case .bitbucket: return "2.0/repositories?fields=values.name,values.owner,values.description"
        }
    }
    
    let metod: RequestMethod
    
    let headers: [String : String]?
    
    let body: [String : Any]?
    
    let origin: DataOrigin
    
    init(metod: RequestMethod, headers: [String : String]? = nil, body: [String : Any]? = nil, origin: DataOrigin) {
        self.metod = metod
        self.headers = headers
        self.body = body
        self.origin = origin
    }
}
