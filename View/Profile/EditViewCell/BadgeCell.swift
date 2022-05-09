//
//  BadgeCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/7.
//

import UIKit

class BadgeCell: UICollectionViewCell {

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var badgeNameLabel: UILabel!
    @IBOutlet weak var waringLabel: UILabel!
    func layoutCell(image: UIImage?, text: String ,textColor: UIColor,waringText: String ) {
        badgeNameLabel.font = .medium(size: 12)
        badgeNameLabel.textColor = textColor
        badgeNameLabel.text = text
        badgeImageView.image = image
        if textColor != .gray {
            waringLabel.isHidden = true
        } else {
            waringLabel.isHidden = false
            waringLabel.font = .medium(size: 10)
            waringLabel.textColor = .B4
            waringLabel.text = waringText
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
