//
//  RepositoriesView.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import SwiftUI

struct RepositoriesView<ViewModelProtocol: RepositoriesViewModelProtocol>: View {
    
    @StateObject private var viewModel: ViewModelProtocol
    
    @State var isFiltered = false
    @State var isReload = false
    
    public init(viewModel: ViewModelProtocol) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
                    .navigationTitle("Multiple repository")
            } else {
                List {
                    Section {
                        NavigationLink {
                            FilterView(viewModel:
                                        FilterViewModel(
                                            sortType: viewModel.sortType,
                                            filteredStrings: viewModel.filteredStrings,
                                            isFiltered: $isFiltered,
                                            repositoriesStore: viewModel.repositoriesStore)
                                       { _, filteredStrings, sortType in
                                viewModel.filteredStrings = filteredStrings
                                viewModel.sortType = sortType
                                isReload.toggle()
                            })
                        } label: {
                            Text("Filter")
                        }
                    }
                    
                    if isFiltered {
                        Section {
                            Button {
                                viewModel.repositoriesStore.sortedRepositories = viewModel.repositoriesStore.repositories
                                viewModel.sortType = .none
                                viewModel.filteredStrings.title = ""
                                viewModel.filteredStrings.nikname = ""
                                withAnimation {
                                    isFiltered = false
                                }
                            } label: {
                                Text("Remove filter")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Section {
                        ForEach(viewModel.repositoriesStore.sortedRepositories, id: \.self) { repo in
                            NavigationLink {
                                DetailView(viewModel: DetailViewModel(repo: repo))
                            } label: {
                                RepositoryCell(repo: repo)
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.refresh()
                    isFiltered = false
                }
                .navigationTitle("Multiple repository")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.refresh()
                            isFiltered = false
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                        }
                        .opacity(viewModel.isReloadButtonShowing ? 1 : 0)
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text("Oups..."),
                  message: Text(viewModel.loadingError),
                  primaryButton: .cancel(),
                  secondaryButton: .default(Text("Reload")) {
                viewModel.refresh()
            })
            //ActionSheet(title: <#T##SwiftUI.Text#>)
        }
        .onAppear {
            Task { await viewModel.getRepo() }
        }
        .onChange(of: isReload) { _ in
        }
    }
    
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView(
            viewModel: RepositoriesViewModel(
                networkManager: RepositoriesNetworkManager(session: URLSession(configuration: .default)),
                coreDataManager: RepositoriesCoreDataManager(persistentContainerName: "Model")))
    }
}
