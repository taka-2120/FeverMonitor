//
//  Users.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//

import SwiftUI

//0 is Primary
struct Users: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var name: String
    var normalTemp: Double
    var tempList: [TempList]        //0 is LATEST
    var chartTemp: [Double]
    var allDate: [Date]
}
