//
//  AuthorizeNotification.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/08/21.
//

import SwiftUI

struct Completion: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "checkmark.circle")
                .symbolRenderingMode(.palette)
                .font(.system(size: 128))
                .foregroundStyle(.green, Color(.label))
            
            Spacer()
            
            Text("all-done")
                .font(Font.title.weight(.bold))
                .padding()
            
            Spacer()
        }
    }
}

struct AuthorizeNC_Previews: PreviewProvider {
    static var previews: some View {
        Completion()
    }
}
