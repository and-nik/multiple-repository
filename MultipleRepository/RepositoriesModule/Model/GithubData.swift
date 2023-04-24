//
//  GithubData.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import Foundation

struct GithubData: Decodable {
    let title: String
    let owner: Owner
    let description: String?
    let repoURL: URL
    
    struct Owner: Decodable {
        let icon: URL
        let url: URL
        let nikname: String
        
        public func getIconData() async throws -> Data {
            let (data, _) = try await URLSession.shared.data(from: icon)
            return data
        }
        
        private enum CodingKeys: String, CodingKey {
            case icon = "avatar_url"
            case nikname = "login"
            case url = "html_url"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "name"
        case repoURL = "html_url"
        case owner, description
    }
    
}
