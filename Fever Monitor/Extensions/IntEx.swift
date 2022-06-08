//
//  Condition.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//

import SwiftUI

extension Int {
    func convertCondition() -> (text: String, color: Color) {
        switch self {
        case 1:
            return (text: "exclamationmark.triangle", color: Color(.systemYellow))
        case 2:
            return (text: "xmark.shield", color: Color(.systemRed))
        default:
            return (text: "checkmark.circle", color: Color(.systemGreen))
        }
    }
}

