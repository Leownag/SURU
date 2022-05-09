//
//  StoreCardsCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/9.
//

import Foundation
import UIKit
import Kingfisher


protocol StoreCardsCellDelegate: AnyObject {
    func didtapCollectionButton(view: StoreCardsCell, storeID: String)
    func didtapUnCollectionButton(view: StoreCardsCell, storeID: String)
}
class StoreCardsCell: UICollectionViewCell {
    weak var delegate: StoreCardsCellDelegate?
    @IBOutlet weak private var storeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak private var followerLabel: UILabel!
    
    @IBOutlet weak private var mostCommentImageView: UIImageView!
    
    @IBOutlet weak private var soupLabel: UILabel!
    @IBOutlet weak private var noodleLabel: UILabel!
    @IBOutlet weak private var overallLabel: UILabel!
    @IBOutlet weak private var soupView: UIView!
    @IBOutlet weak private var noodleView: UIView!
    @IBOutlet weak private var overallView: UIView!
    
    @IBOutlet weak var nonReportLabel: UILabel!
    @IBOutlet weak private var reportView: UIView!
    @IBOutlet weak private var reportLabel: UILabel!
    @IBOutlet weak private var reportPeopleLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    
    
    @IBOutlet weak private var collectButton: UIButton!
    @IBAction func tapCollectButton(_ sender: UIButton) {
        guard let image = sender.image(for: .normal) else { return }
        guard let storeData = storeData else { return }
        guard let commentsData = commentsData else { return }
        if image == UIImage(named: "collect.fill") {
            
            collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
            followerLabel.text = "\(storeData.collectedUser?.count ?? 1 - 1) 人收藏, 共\(commentsData.count) 則食記"
            self.delegate?.didtapUnCollectionButton(view: self, storeID: storeData.storeID)
            
        } else {
            
            collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
            followerLabel.text = "\(storeData.collectedUser?.count ?? 0 + 1) 人收藏, 共\(commentsData.count) 則食記"
            self.delegate?.didtapCollectionButton(view: self, storeID: storeData.storeID)
        }
    }
    var storeData: Store?
    var commentsData: [Comment]?
    
    func layoutCardView(dataSource: Store, commentData: [Comment], isCollect: Bool) {
        self.contentView.makeShadow()
        self.contentView.clipsToBounds = true
        storeData = dataSource
        commentsData = commentData
        self.clipsToBounds = true
        self.cornerForAll(radii: 10)
        reportView.clipsToBounds = true
        reportView.cornerForAll(radii: 10)
        dotView.clipsToBounds = true
        dotView.layer.cornerRadius = 7.5
        soupView.clipsToBounds = true
        noodleView.clipsToBounds = true
        overallView.clipsToBounds = true
        soupView.layer.cornerRadius = 20
        noodleView.layer.cornerRadius = 20
        overallView.layer.cornerRadius = 20
        nameLabel.text = dataSource.name
        mostCommentImageView.clipsToBounds = true
        mostCommentImageView.cornerForAll(radii: 10)
        mostCommentImageView.makeShadow()
        storeImageView.layer.cornerRadius = 25
        storeImageView.clipsToBounds = true
        storeImageView.kf.setImage(with: URL(string: dataSource.mainImage), placeholder:  UIImage(named: "AppIcon"))
        storeImageView.layer.borderWidth = 1.0
        storeImageView.layer.borderColor = UIColor.black.cgColor
        followerLabel.text = "\(dataSource.collectedUser?.count ?? 0) 人收藏, 共\(commentData.count) 則食記"
        collectButton.setTitle("", for: .normal)
        if isCollect {
            collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
        } else {
            collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
        }
        let weekday = Date().weekDay()
        if dataSource.opentime.byPropertyName(weekDay: weekday).dinner == "close" && dataSource.opentime.byPropertyName(weekDay: weekday).lunch == "close" {
            dotView.backgroundColor = .red
        } else {
            dotView.backgroundColor = .systemGreen
        }
        var soup: Double = 0
        var noodle: Double = 0
        var happy: Double = 0
        
        if !commentData.isEmpty {
            let mostComment = commentData.sorted(by: {$0.likedUserList.count > $1.likedUserList.count})
            mostCommentImageView.kf.setImage(with: URL(string: mostComment[0].mainImage), placeholder: UIImage(named: "man\(Int.random(in: 1..<8))"))
            
            for comment in commentData {
                soup += comment.contentValue.soup
                noodle += comment.contentValue.noodle
                happy += comment.contentValue.happiness
            }
            let count = Double(commentData.count)
            let data = [(soup/count).ceiling(toDecimal: 1),
                        (noodle/count).ceiling(toDecimal: 1),
                        (happy/count).ceiling(toDecimal: 1)
            ]
            if data[0] == 10.0 {
                soupLabel.text = String(10)
            } else {
                soupLabel.text = String(data[0])
            }
            if data[1] == 10.0 {
                noodleLabel.text = String(10)
            } else {
                noodleLabel.text = String(data[1])
            }
            if data[2] == 10.0 {
                overallLabel.text = String(10)
            } else {
                overallLabel.text = String(data[2])
            }
            
        } else {
            mostCommentImageView.image = UIImage(named: "man\(Int.random(in: 1..<8))")
            
            soupLabel.text = "無"
            soupLabel.textColor = .B1
//            soupLabel.font = .medium(size: 6)
            noodleLabel.text = "無"
            noodleLabel.textColor = .B1
//            noodleLabel.font = .medium(size: 6)
            overallLabel.text = "無"
            overallLabel.textColor = .B1
//            overallLabel.font = .medium(size: 6)
        }
        reportLabel.textColor = .red
        
        reportLabel.font = .medium(size: 18)
        reportPeopleLabel.isHidden = false
        reportLabel.isHidden = false
        nonReportLabel.isHidden = true
        switch cogfigReport(store: dataSource) {
        case 1:
            reportLabel.text = "0~5"
        case 2:
            reportLabel.text = "5~10"
        case 3:
            reportLabel.text = "10~20"
        case 4:
            reportLabel.text = "20+"
        
        default :
            reportLabel.isHidden = true
            nonReportLabel.isHidden = false
            reportPeopleLabel.isHidden = true
        }
        
    }
    private func cogfigReport(store: Store) -> Int {
        guard let reports = store.queueReport else { return 5 }
        let date = Double(Date().timeIntervalSince1970)
        if !reports.isEmpty {
            guard let report = reports.sorted(by: {$0.createdTime > $1.createdTime}).first else { return 0 }
            if (report.createdTime + 60*60*3) > date {
                return report.queueCount
            } else {
                return 5
            }
        }
        return 5
    }
    
}
