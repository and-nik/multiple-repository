//
//  Checkmark.swift
//  MultipleRepository
//
//  Created by And Nik on 22.04.23.
//

import SwiftUI

struct Checkmark<Label: View>: View {
    
    @Binding var status: SortType
    var element: SortType
    var action: () -> Void
    @ViewBuilder var label: () -> Label
    
    init(_ status: Binding<SortType>, equaleTo element: SortType, action: @escaping () -> Void, label: @escaping () -> Label) {
        self._status = status
        self.element = element
        self.action = action
        self.label = label
    }
    
    var body: some View {
        HStack {
            Button {
                status = element
                action()
            } label: {
                Circle()
                    .fill(status == element ? Color(uiColor: .tintColor) : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(Color(uiColor: .gray), lineWidth: 2)
                            .padding(-5))
            }
            label()
        }
    }
    
    
}
