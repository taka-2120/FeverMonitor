//
//  MesureTempHelp.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2021/01/25.
//

import SwiftUI

struct MeasureTempHelp: View {
    @Binding var sheet: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("measure-method-1")
                    .padding(.bottom)
                Text("measure-method-2")
                    .padding(.bottom)
                Text("measure-temp-note")
                    .font(.system(size: 13))
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(.bottom, 8)
                Spacer()
            }
            .font(.body)
            .padding()
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle("measure-correctly-title")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear() {
            sheet = false
        }
    }
}
