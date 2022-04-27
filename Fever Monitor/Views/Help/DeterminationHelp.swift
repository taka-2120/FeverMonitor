//
//  DeterminationHelp.swift.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2021/10/16.
//

import SwiftUI

struct DeterminationHelp: View {
    @Binding var sheet: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Image(colorScheme == .dark ? "HelpGraph_Dark" : "HelpGraph_Light")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("determination-note")
                .font(.title3)
                .padding(5)
            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.automatic)
        .onDisappear() {
            sheet = false
        }
    }
}
