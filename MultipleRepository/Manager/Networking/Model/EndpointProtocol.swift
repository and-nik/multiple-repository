//
//  EndpointProtocol.swift
//  MultipleRepository
//
//  Created by And Nik on 21.04.23.
//

import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var metod: RequestMethod { get }
    var headers: [String : String]? { get }
    var body: [String : Any]? { get }
}
