//
//  StoreCardView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/22.
//

import Foundation
import UIKit
import Cosmos

class StoreCardView: UIView {
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var middleImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avgRatingView: CosmosView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var tagsStackView: UIStackView!
    @IBOutlet weak var localtionAreaLabel: UILabel!
    @IBOutlet weak var openingWaringLabel: UILabel!
    @IBOutlet weak var timeUntillLabel: UILabel!
    
    func layoutCardView(dataSource: Store) {
        self.backgroundColor = .black.withAlphaComponent(0.7)
        self.clipsToBounds = true
        self.nameLabel.text = dataSource.name
       
    }
}


