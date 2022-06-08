//
//  CircleNavigationButton.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/08.
//

import SwiftUI

struct CircleNavigationButton: View {
    @Binding var isShown: Bool
    var icon: String
    var destination: AnyView
    
    var body: some View {
        Button(action: {
            isShown = true
        }, label: {
            Image(systemName: icon)
                .foregroundColor(Color("AccentColor"))
                .font(.title2)
        })
        .frame(minWidth: 60, minHeight: 60)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(30)
        .shadow(radius: 8)
        .sheet(isPresented: $isShown) {
            destination
        }
    }
}

struct CircleNavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleNavigationButton(
            isShown: .constant(false),
            icon: "gearshape.fill",
            destination: AnyView(EmptyView())
        )
    }
}
