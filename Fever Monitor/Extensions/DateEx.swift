//
//  Date.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//

import Foundation

extension Date {
    func formatDateToString(showDate: Bool, showTime: Bool) -> String {
        let dateFormatter = DateFormatter()
        
        if showDate == true {
            dateFormatter.dateStyle = .medium
        }
        if showTime == true {
            dateFormatter.timeStyle = .short
        }
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en-US")
        
        return dateFormatter.string(from: self)
    }
    
    func getLastWeek() -> [Date] {
        var lastWeek = [Date]()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        for i in 0..<7 {
            let day = calendar.date(byAdding: .day, value: -i, to: self)!
            lastWeek.append(day)
        }
        print(lastWeek)
        
        return lastWeek
    }
}
