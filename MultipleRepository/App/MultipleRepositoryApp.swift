//
//  MultipleRepositoryApp.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import SwiftUI

@main
struct MultipleRepositoryApp: App {
    var body: some Scene {
        WindowGroup {
            RepositoriesView(viewModel: RepositoriesViewModel(networkManager: RepositoriesNetworkManager(session: URLSession(configuration: .default))))
        }
    }
}
