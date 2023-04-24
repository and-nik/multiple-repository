//
//  Bitbucket.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import Foundation

struct Bitbucket: Decodable {
    let repos: [BitbucketData]
    
    private enum CodingKeys: String, CodingKey {
        case repos = "values"
    }
    
    struct BitbucketData: Decodable {
        let title: String
        let owner: Owner
        let description: String?
        
        private enum CodingKeys: String, CodingKey {
            case title = "name"
            case owner, description
        }
        
        struct Owner: Decodable {
            let links: Links
            let name: String
            
            struct Links: Decodable {
                let avatar: Avatar
                let html: OwnerLink
                
                struct Avatar: Decodable {
                    let icon: URL
                    
                    public func getIconData() async throws -> Data {
                        let (data, _) = try await URLSession.shared.data(from: icon)
                        return data
                    }
                    
                    private enum CodingKeys: String, CodingKey {
                        case icon = "href"
                    }
                }
                
                struct OwnerLink: Decodable {
                    let href: URL
                }
            }
            
            private enum CodingKeys: String, CodingKey {
                case name = "display_name"
                case links
            }
        }
    }
}
