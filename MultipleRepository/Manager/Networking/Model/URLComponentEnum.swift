//
//  URLComponentEnum.swift
//  MultipleRepository
//
//  Created by And Nik on 26.04.23.
//

import Foundation

enum Scheme: String {
    case https = "https://"
    case ws = "ws"
}

enum baseURL: String {
    case github = "api.github.com/"
    case bitbucket = "api.bitbucket.org/2.0/"
}

enum Path: String {
    case repositories = "repositories?"
}

func ddd(s: Scheme, url: baseURL) -> String {
    s.rawValue + url.rawValue
}


