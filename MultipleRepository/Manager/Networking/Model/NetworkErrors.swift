//
//  NetworkErrors.swift
//  MultipleRepository
//
//  Created by And Nik on 27.04.23.
//

import Foundation

enum NetworkErrors: Error {
    case invalidURL
    case noResponse
    case invalidDecodeData
    case unauthorized
    case unexpectedStatusCode
}
