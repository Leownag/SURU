//
//  StoreDataModel.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Foundation

struct Store: Codable {
    var storeID: String = ""
    var name: String
    var engName: String
    var area: String
    var facebookLink: String
    var note: String
    var address: String
    var coordinate: Coordinate
    var phone: String = ""
    var tags: [String]
    var meals: [String]
    var seat: String
    var opentime: Opentime
    var menuImage: String
    var mainImage: String
    var closeDay: [Int] = []
    var queueReport: [QueueReport]? = []
    var collectedUser: [String]? = []
}
struct Coordinate: Codable {
    var long: Double
    var lat: Double
}
struct Opentime: Codable {
    var sun: Time
    var mon: Time
    var tue: Time
    var wed: Time
    var thu: Time
    var fri: Time
    var sat: Time
    
    func byPropertyName(weekDay: String) -> Time {
            switch weekDay {
            case "sun": return sun
            case "mon": return mon
            case "tue": return tue
            case "wed": return wed
            case "thu": return thu
            case "fri": return fri
            case "sat": return sat
            default: fatalError("Wrong property name")
            }
        }
}
struct Time: Codable {
    var lunch: String
    var dinner: String
}
