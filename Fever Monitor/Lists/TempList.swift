//
//  TempList.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//

import SwiftUI

struct TempList: Identifiable, Hashable, Codable{
    var id = UUID()
    var condition: Int  //0->Normal, 1->Slight, 2->Severe
    var temp: Double
    var date: Date
}
