//
//  String+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import Foundation

extension String {
func toYYYYMMDDHHMM() -> String {
    
    let date = NSDate(timeIntervalSince1970: Double(self)!)
    let dateFormatter = DateFormatter()

    // Set Date Format
    dateFormatter.dateFormat = "y/M/d hh:mm"

    // Convert Date to String
    return dateFormatter.string(from: date as Date)
}
}
