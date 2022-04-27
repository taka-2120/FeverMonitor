//
//  UserSettings.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2021/09/20.
//

import SwiftUI

struct UserSettings: View {
    var body: some View {
        VStack {
            
            Spacer()
            
            Image(systemName: "person.fill")
                .font(.system(size: 128))
                .foregroundColor(Color(.systemOrange))
            
            Spacer()
            
            Text("user-settings")
                .font(Font.title.weight(.bold))
                .padding()
            
            Text("user-settings-desc")
                .padding(.horizontal, 20)
                .font(.body)
                .foregroundColor(Color(.secondaryLabel))
            
            Text("user-name-note")
                .padding()
                .font(.callout)
                .foregroundColor(Color(.secondaryLabel))
            
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}

struct UserSettings_Previews: PreviewProvider {
    static var previews: some View {
        UserSettings()
    }
}


