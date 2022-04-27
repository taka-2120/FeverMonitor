//
//  TempField.swift
//  Fever Monitor
//
//  Created by Yu on 2022/04/22.
//

import SwiftUI

struct TempField: View {
    
    @State var upper = ""
    @State var under = ""
    var normalTemp: Bool
    
    var body: some View {
        HStack(spacing: 5) {
            if normalTemp {
                Text("3")
            }
            
            TextField("", text: $upper)
                .multilineTextAlignment(.center)
                .frame(maxWidth: normalTemp ? 50 : 100)
                .background(Color("SubBackground"))
                .cornerRadius(10)
                .keyboardType(.numberPad)
                .limitInputLength(value: $upper, length: normalTemp ? 1 : 2)
            
            Text(".")
            
            TextField("", text: $under)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 50)
                .background(Color("SubBackground"))
                .cornerRadius(10)
                .keyboardType(.numberPad)
                .limitInputLength(value: $under, length: 1)
            
            Text(" \(degree)C")
        }
        .frame(maxWidth: 280, maxHeight: 60)
        .font(.system(size: 64))
        .padding(.top, 30)
    }
}
