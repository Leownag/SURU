//
//  String+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import Foundation
import UIKit

extension String {
    func toYYYYMMDDHHMM() -> String {
        let date = NSDate(timeIntervalSince1970: Double(self)!)
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "y/M/d hh:mm"
        // Convert Date to String
        return dateFormatter.string(from: date as Date)
    }
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
}
