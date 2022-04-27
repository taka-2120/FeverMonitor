//
//  Authorization.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2021/12/15.
//

import SwiftUI

struct Authorization: View {
    
    @Binding var showModal: Bool
    
    var body: some View {
        VStack {
            Text("welcome")
                .font(Font.largeTitle.weight(.bold))
                .padding(.top)
            
            Spacer()
            
            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                .font(.system(size: 128))
                .foregroundColor(Color(.systemPink))
            
            Spacer()
            
            Text("auth")
                .font(Font.title.weight(.bold))
                .padding()
            
            Text("auth-description")
                .padding(.horizontal, 20)
                .font(.body)
                .foregroundColor(Color(.secondaryLabel))
            
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}
