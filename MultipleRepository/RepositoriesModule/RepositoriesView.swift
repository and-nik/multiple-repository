//
//  RepositoriesView.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import SwiftUI

struct RepositoriesView<viewModelProtocol: RepositoriesViewModelProtocol>: View {
    
    @StateObject private var viewModel: viewModelProtocol
    
    @State var isFiltered = false
    
    public init(viewModel: viewModelProtocol) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
            } else {
                
                if viewModel.isReloadButtonShowing {
                    Button {
                        viewModel.refresh()
                        isFiltered = false
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 25, height: 25)
                    }
                } else {
                    List {
                        Section {
                            NavigationLink {
                                FilterView(viewModel:
                                            FilterViewModel(repositories: viewModel.repositories,
                                                            allRepositories: viewModel.allRepositories,
                                                            sortType: viewModel.sortType,
                                                            filteredStrings: viewModel.filteredStrings, isFiltered: $isFiltered)
                                           { repos, filteredStrings, sortType in
                                    viewModel.repositories = repos
                                    viewModel.filteredStrings = filteredStrings
                                    viewModel.sortType = sortType
                                })
                            } label: {
                                Text("Filter")
                            }
                        }
                        
                        if isFiltered {
                            Section {
                                Button {
                                    withAnimation {
                                        isFiltered = false
                                    }
                                    viewModel.repositories = viewModel.allRepositories
                                    viewModel.sortType = .none
                                    viewModel.filteredStrings.title = ""
                                    viewModel.filteredStrings.nikname = ""
                                } label: {
                                    Text("Remove filter")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        Section {
                            ForEach(viewModel.getRepositoriesCells()) { cell in
                                NavigationLink {
                                    DetailView(viewModel: DetailViewModel(repo: cell.repo))
                                } label: {
                                    cell
                                }
                            }
                        }
                    }
                    .refreshable {
                        viewModel.refresh()
                        isFiltered = false
                    }
                    .navigationTitle("Multiple repository")
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
    }
    
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView(viewModel: RepositoriesViewModel(networkManager: RepositoriesNetworkManager()))
    }
}



//@ObservedObject private var viewModel: viewModelProtocol
//
//public init(viewModel: viewModelProtocol) {
//    self.viewModel = viewModel
//}



//                HStack {
//                    Button {
//                        sortType = .gitToBit
//                        filter()
//                    } label: {
//                        Circle()
//                            .fill(sortType == .gitToBit ? Color(uiColor: .tintColor) : .clear)
//                            .frame(width: 15, height: 15)
//                            .background(
//                                Circle()
//                                    .stroke(Color(uiColor: .gray), lineWidth: 2)
//                                    .padding(-5))
//                    }
//                    Text("Github -> Bitebucket")
//                }


//HStack {
//    Button {
//        sortType = .bitToGit
//        filter()
//    } label: {
//        Circle()
//            .fill(sortType == .bitToGit ? Color(uiColor: .tintColor) : .clear)
//            .frame(width: 15, height: 15)
//            .background(
//                Circle()
//                    .stroke(Color(uiColor: .gray), lineWidth: 2)
//                    .padding(-5))
//    }
//
//}
//HStack {
//    Button {
//        sortType = .AToZ
//        filter()
//    } label: {
//        Circle()
//            .fill(sortType == .AToZ ? Color(uiColor: .tintColor) : .clear)
//            .frame(width: 15, height: 15)
//            .background(
//                Circle()
//                    .stroke(Color(uiColor: .gray), lineWidth: 2)
//                    .padding(-5))
//    }
//    Text("A -> Z")
//}
//HStack {
//    Button {
//        sortType = .ZToA
//        filter()
//    } label: {
//        Circle()
//            .fill(sortType == .ZToA ? Color(uiColor: .tintColor) : .clear)
//            .frame(width: 15, height: 15)
//            .background(
//                Circle()
//                    .stroke(Color(uiColor: .gray), lineWidth: 2)
//                    .padding(-5))
//    }
//    Text("Z -> A")
//}


//viewModel.repositories = sorted
//.filter { filterRepoString != "" ? $0.title.lowercased().contains(filterRepoString.lowercased()) : false }
//.filter { $0.ownerNikname != nil && filterNiknameString != "" ? $0.ownerNikname!.lowercased().contains(filterNiknameString.lowercased()) : true }


//Section {
//    HStack {
//        Button {
//            filterType = .repoTitle
//        } label: {
//            Circle()
//                .fill(filterType == .repoTitle ? Color(uiColor: .tintColor) : .clear)
//                .frame(width: 15, height: 15)
//                .background(
//                    Circle()
//                        .stroke(Color(uiColor: .gray), lineWidth: 2)
//                        .padding(-5))
//        }
//        Text("Repository title")
//    }
//    HStack {
//        Button {
//            filterType = .nikname
//        } label: {
//            Circle()
//                .fill(filterType == .nikname ? Color(uiColor: .tintColor) : .clear)
//                .frame(width: 15, height: 15)
//                .background(
//                    Circle()
//                        .stroke(Color(uiColor: .gray), lineWidth: 2)
//                        .padding(-5))
//        }
//        Text("Nikname")
//    }
//    HStack {
//        Button {
//            filterType = .origin
//        } label: {
//            Circle()
//                .fill(filterType == .origin ? Color(uiColor: .tintColor) : .clear)
//                .frame(width: 15, height: 15)
//                .background(
//                    Circle()
//                        .stroke(Color(uiColor: .gray), lineWidth: 2)
//                        .padding(-5))
//        }
//        Text("Origin")
//    }
//
//} header: {
//    Text("Filter by")
//}
