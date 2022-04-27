//
//  DataList.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/08/18.
//

import SwiftUI

struct TempList: Identifiable , Hashable{
    var id = UUID()
    //0->Normal, 1->Slight, 2->Severe
    var condition: Int
    
    var temp: CGFloat
    var date: Date
}

struct ChartList {
    var id = UUID()
    var x: CGFloat
    var temp: CGFloat
    var date: Date
    var multi: Bool
}
