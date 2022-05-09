//
//  StoreCardViewCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/23.
//

import Foundation
import UIKit
import Kingfisher
import Cosmos

class StoreCardCell: UICollectionViewCell {
    @IBOutlet weak private var leftImageView: UIImageView! {
        didSet {
            leftImageView.clipsToBounds = true
            leftImageView.layer.cornerRadius = 10
            leftImageView.image = UIImage(named: "man\(Int.random(in: 1..<8))")
        }
    }
    @IBOutlet weak private var middleImageView: UIImageView! {
        didSet {
            middleImageView.clipsToBounds = true
            middleImageView.layer.cornerRadius = 10
            middleImageView.image = UIImage(named: "man\(Int.random(in: 1..<8))")
        }
    }
    @IBOutlet weak private var rightImageView: UIImageView! {
        didSet {
            rightImageView.clipsToBounds = true
            rightImageView.layer.cornerRadius = 10
            rightImageView.image = UIImage(named: "man\(Int.random(in: 1..<8))")
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak private var avgRatingView: CosmosView!
    @IBOutlet weak private var ratingCountLabel: UILabel!
    @IBOutlet weak private var tagsView: UIStackView!
    @IBOutlet weak private var localtionAreaLabel: UILabel!
    @IBOutlet weak private var openingWaringLabel: UILabel!
    @IBOutlet weak private var timeUntillLabel: UILabel!
    @IBOutlet weak private var lunchLabel: UILabel!
    @IBOutlet weak private var dinnerLabel: UILabel!
    @IBOutlet weak private var distanceLabel: UILabel!
    
    func layoutCardView(dataSource: Store, commentData: [Comment], areaName: String, distance: Double) {
        self.backgroundColor = .white.withAlphaComponent(0.7)
        self.clipsToBounds = true
        self.cornerForAll(radii: 10)
        self.nameLabel.text = dataSource.name
        self.localtionAreaLabel.text = dataSource.area
        let weekday =  getTodayWeekDay()
        switch weekday {
        case "sun" :
            self.lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.sun.lunch)"
            self.dinnerLabel.text = "晚餐: \(dataSource.opentime.sun.dinner)"
        case "mon" :
            self.lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.mon.lunch)"
            self.dinnerLabel.text = "晚餐: \(dataSource.opentime.mon.dinner)"
        case "tue" :
            self.lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.tue.lunch)"
            self.dinnerLabel.text = "晚餐: \(dataSource.opentime.tue.dinner)"
        case "wed" :
            self.lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.wed.lunch)"
            self.dinnerLabel.text = "晚餐: \(dataSource.opentime.wed.dinner)"
        case "thu" :
            self.lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.thu.lunch)"
            self.dinnerLabel.text = "晚餐: \(dataSource.opentime.thu.dinner)"
        case "fri" :
            self.lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.fri.lunch)"
            self.dinnerLabel.text = "晚餐: \(dataSource.opentime.fri.dinner)"
        case "sat" :
            self.lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.sat.lunch)"
            self.dinnerLabel.text = "晚餐: \(dataSource.opentime.sat.dinner)"
        default:
            return
        }
//        var total: Double = 0
//        for data in commentData {
//            let value = (data.contentValue.happiness + data.contentValue.soup + data.contentValue.noodle)/3
//            total += value
//        }
        if commentData.count > 0 {
            var total: Double = 0
            for data in commentData {
                let value = (data.contentValue.happiness + data.contentValue.soup + data.contentValue.noodle)/3
                total += value
            }
        ratingCountLabel.text = "\(commentData.count) reviews"
            avgRatingView.rating = total/Double(commentData.count)
        } else {
            ratingCountLabel.text = "no review"
            avgRatingView.rating = 0
        }
//        avgRatingView.rating = total/Double(commentData.count)
        let kilometer = Double(distance/1000).ceiling(toDecimal: 1)
        self.distanceLabel.text = String("\(kilometer) 公里")
        if !commentData.isEmpty {
            leftImageView.kf.setImage(with: URL(string: commentData.first!.mainImage))
        }
       
    }
    func getTodayWeekDay()-> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEE"
        let weekDay = dateFormatter.string(from: Date()).lowercased()
           return weekDay
     }

}
