//
//  TempList.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/08.
//

import SwiftUI

extension Sequence where Iterator.Element == TempList {
    func forChart(lastWeek: [Date]) -> [Double] {
        var chartTemp = [Double]()
        
        for i in 0..<7 {
            let matched = self.filter({
                $0.date.formatDateToString(
                    showDate: true,
                    showTime: false)
                ==
                lastWeek[i].formatDateToString(
                    showDate: true,
                    showTime: false)
            })
            
            if matched.count == 0 {
                break
            }
            
            var totalTemp: Double = 0
            var avgTemp: Double = 0
            
            for j in 0..<matched.count {
                totalTemp += matched[j].temp
            }
            
            avgTemp = totalTemp / Double(matched.count)
            chartTemp.append(avgTemp)
        }
        
        print(chartTemp)
        return chartTemp
    }
}
