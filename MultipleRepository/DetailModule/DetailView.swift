//
//  DetailView.swift
//  MultipleRepository
//
//  Created by And Nik on 21.04.23.
//

import SwiftUI

struct DetailView<ViewModelProtocol: DetailViewModelProtocol>: View {
    
    @ObservedObject private var viewModel: ViewModelProtocol
    
    public init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            //image...
            Section {
            } header: {
                HStack {
                    Spacer()
                    Image(uiImage: UIImage(data: viewModel.repo.userIcon) ?? UIImage(systemName: "person.fill")!)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                        .clipShape(Capsule())
                        .padding(.bottom, 20)
                        .foregroundColor(Color(uiColor: .label))
                    Spacer()
                }
            }
            //repo...
            Section {
                NavigationLink {
                    if let url = viewModel.repo.repoURL {
                        WebView(url: url)
                            .navigationBarTitleDisplayMode(.inline)
                    } else {
                        Text("Bad URL")
                    }
                } label: {
                    HStack {
                        Text(viewModel.repo.title)
                        Spacer()
                        Text(viewModel.repo.dataOrigin == .github ? "Go to Github" : "Go to Bitebucket")
                            .foregroundColor(Color(uiColor: .gray))
                        Image(viewModel.repo.dataOrigin == .bitbucket ? "bitbucket" : "github")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 15, height: 15)
                    }
                }
            } header: {
                Text("Repository fullname")
            }
            //owwner...
            Section {
                NavigationLink {
                    if let url = viewModel.repo.ownerURL {
                        WebView(url: url)
                            .navigationBarTitleDisplayMode(.inline)
                    } else {
                        Text("Bad URL")
                    }
                } label: {
                    HStack {
                        Text(viewModel.repo.ownerNikname ?? "Unknowed name")
                        Spacer()
                        Text(viewModel.repo.dataOrigin == .github ? "Go to Github" : "Go to Bitebucket")
                            .foregroundColor(Color(uiColor: .gray))
                        Image(viewModel.repo.dataOrigin == .bitbucket ? "bitbucket" : "github")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 15, height: 15)
                    }
                }
            } header: {
                Text("Repository owner")
            }
            //description...
            Section {
                Text(viewModel.repo.description)
            } header: {
                Text("Repository description")
            }
        }
        .navigationTitle(viewModel.repo.title)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = Repository(title: "title",
                              userIcon: Data(),
                              description: "descffffff",
                              dataOrigin: .github,
                              ownerNikname: "Fgg dds",
                              ownerURL: nil,
                              repoURL: nil)
        DetailView(viewModel: DetailViewModel(repo: repo))
    }
}
