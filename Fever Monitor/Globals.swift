//
//  Globals.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//

import SwiftUI

let degree = NSString(format: "%@", "\u{00B0}") as String

let gradient = LinearGradient(
    gradient: Gradient(
        colors: [Color("Header_Gradient_Start"),
                 Color("Header_Gradient_End")
                ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
