//
//  BadgeHeaderCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/6.
//

import UIKit

class BadgeHeaderCell: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .B3
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
