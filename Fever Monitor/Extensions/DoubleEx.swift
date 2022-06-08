//
//  String.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//

import SwiftUI

extension Double {
    func toTempString() -> String {
        return "\(String(format: "%.1f", self)) \(degree)C"
    }
}
