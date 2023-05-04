//
//  FilterView.swift
//  MultipleRepository
//
//  Created by And Nik on 22.04.23.
//

import SwiftUI

struct FilterView<ViewModelProtocol: FilterViewModelProtocol>: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModelProtocol
    
    public init(viewModel: ViewModelProtocol) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        //self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            
            Text("Available \(viewModel.count) items")
                .frame(maxWidth: .infinity)
                .onChange(of: viewModel.repositoriesStore.sortedRepositories.count) { newValue in
                    
                }
            
            Section {
                TextField("Enter title", text: $viewModel.filteredStrings.title)
                    .onChange(of: viewModel.filteredStrings.title) { newValue in
                        viewModel.filter()
                    }
            } header: {
                Text("Repository title")
            }
            
            Section {
                TextField("Enter nikname", text: $viewModel.filteredStrings.nikname)
                    .onChange(of: viewModel.filteredStrings.nikname) { newValue in
                        viewModel.filter()
                    }
            } header: {
                Text("Nikname")
            }
            
            Section {
                Checkmark($viewModel.sortType, equaleTo: .gitToBit) {
                    viewModel.filter()
                } label: {
                    Text("Github -> Bitebucket")
                        .padding(.leading, 20)
                }
                Checkmark($viewModel.sortType, equaleTo: .bitToGit) {
                    viewModel.filter()
                } label: {
                    Text("Bitebucket -> Github")
                        .padding(.leading, 20)
                }
                Checkmark($viewModel.sortType, equaleTo: .AToZ) {
                    viewModel.filter()
                } label: {
                    Text("A -> Z")
                        .padding(.leading, 20)
                }
                Checkmark($viewModel.sortType, equaleTo: .ZToA) {
                    viewModel.filter()
                } label: {
                    Text("Z -> A")
                        .padding(.leading, 20)
                }
            } header: {
                Text("Sort by")
            }
            
            Section {
                Button {
                    viewModel.sortType = .none
                    viewModel.filter()
                } label: {
                    Text("Remove sort")
                }
                .frame(maxWidth: .infinity)
            }
            
        }
        .navigationTitle("Filter")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            if viewModel.filteredStrings.title != "" || viewModel.filteredStrings.nikname != "" || viewModel.sortType != .none {
                withAnimation {
                    viewModel.isFiltered = true
                }
            } else {
                viewModel.repositoriesStore.sortedRepositories = viewModel.repositoriesStore.repositories
                withAnimation {
                    viewModel.isFiltered = false
                }
            }
            viewModel.completion([], viewModel.filteredStrings, viewModel.sortType)
        }
    }
}
