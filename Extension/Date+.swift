//
//  Date+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/13.
//

import Foundation

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
                
        return formatter
    }
    func weekDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let weekDay = dateFormatter.string(from: self).lowercased()
        return weekDay
    }
    
}
