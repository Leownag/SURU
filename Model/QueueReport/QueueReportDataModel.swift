//
//  QueueReportDataModel.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Foundation

struct QueueReport: Codable {
    var storeID: String
    var reportID: String = ""
    var queueCount: Int
    var createdTime: Double = 0
}
