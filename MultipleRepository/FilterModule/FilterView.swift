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













//var body: some View {
//    Group {
//        Section {
//            Checkmark($sortType, equaleTo: .gitToBit) {
//                filter()
//            } label: {
//                Text("Github -> Bitebucket")
//            }
//            Checkmark($sortType, equaleTo: .bitToGit) {
//                filter()
//            } label: {
//                Text("Bitebucket -> Github")
//            }
//            Checkmark($sortType, equaleTo: .AToZ) {
//                filter()
//            } label: {
//                Text("A -> Z")
//            }
//            Checkmark($sortType, equaleTo: .ZToA) {
//                filter()
//            } label: {
//                Text("Z -> A")
//            }
//        } header: {
//            Text("Sort by")
//        }
//        Button {
//            sortType = .none
//            filter()
//        } label: {
//            Text("Remove sort")
//        }
//        Text("Repository title")
//        TextField("Enter title", text: $filterRepoString)
//            .onChange(of: filterRepoString) { newValue in
//                filter()
//            }
//        Text("Nikname")
//        TextField("Enter nikname", text: $filterNiknameString)
//            .onChange(of: filterNiknameString) { newValue in
//                filter()
//            }
//        
//        Text("\(viewModel.repositories.count)")
//    }
//}
//
//func filter() {
//    viewModel.repositories = viewModel.repos
//    switch sortType {
//    case .gitToBit:
//        viewModel.repositories = viewModel.repositories.sorted { $0.dataOrigin.rawValue < $1.dataOrigin.rawValue }
//    case .bitToGit:
//        viewModel.repositories = viewModel.repositories.sorted { $0.dataOrigin.rawValue > $1.dataOrigin.rawValue }
//    case .AToZ:
//        viewModel.repositories = viewModel.repositories.sorted { $0.title < $1.title }
//    case .ZToA:
//        viewModel.repositories = viewModel.repositories.sorted { $0.title > $1.title }
//    case .none: break
//    }
//    print("ff")
//    viewModel.repositories = viewModel.repositories
//    .filter { filterRepoString != "" ? $0.title.lowercased().contains(filterRepoString.lowercased()) : true }
//    .filter { $0.ownerNikname != nil && filterNiknameString != "" ? $0.ownerNikname!.lowercased().contains(filterNiknameString.lowercased()) : true }
//}
