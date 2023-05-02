//
//  RepositoryCell.swift
//  MultipleRepository
//
//  Created by And Nik on 20.04.23.
//

import SwiftUI

struct RepositoryCell: View, Identifiable {
    let id = UUID()
    let repo: Repository
    
    var body: some View {
        
        VStack {
            HStack {
                Image(uiImage: UIImage(data: repo.userIcon) ?? UIImage(systemName: "person.fill")!)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .scaledToFill()
                    .clipShape(Capsule())
                    .foregroundColor(Color(uiColor: .label))
                Text(repo.ownerNikname ?? "Unknowed nikname")
                Spacer()
                Image(repo.dataOrigin == .bitbucket ? "bitbucket" : "github")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 15, height: 15)
            }
            Text(repo.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.body.bold())
            Text(repo.description)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}

struct RepositoryCell_Previews: PreviewProvider {
    static var previews: some View {
        let repo = Repository(title: "title",
                               userIcon: Data(),
                               description: "descffffff",
                               dataOrigin: .github,
                               ownerNikname: "Fgg dds",
                               ownerURL: nil,
                               repoURL: nil)
         return RepositoryCell(repo: repo)
    }
}
