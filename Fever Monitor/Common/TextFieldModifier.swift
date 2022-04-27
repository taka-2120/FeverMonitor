//
//  TextFieldModifier.swift
//  Fever Monitor
//
//  Created by Yu on 2022/04/22.
//

import SwiftUI
import Combine

struct TextFieldLimitModifier: ViewModifier {
    @Binding var value: String
    var length: Int
    
    func body(content: Content) -> some View {
        content
            .onReceive(Just(value)) {
                value = String($0.prefix(length))
            }
    }
}


extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        modifier(TextFieldLimitModifier(value: value, length: length))
    }
}
