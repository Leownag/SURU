//
//  StoreRatingCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import UIKit

class StoreRatingCell: UITableViewCell {

    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    func layoutCell(data: [Double]? = [0,0,0]) {
        guard let data = data else {
            return
        }
        leftView.layer.cornerRadius = leftView.bounds.width/2
        leftView.clipsToBounds = true
        midView.layer.cornerRadius = midView.bounds.width/2
        midView.clipsToBounds = true
        rightView.layer.cornerRadius = rightView.bounds.width/2
        rightView.clipsToBounds = true
        leftView.backgroundColor = .systemYellow
        midView.backgroundColor = .systemBlue
        rightView.backgroundColor = .systemPink
        if data[0].isNaN {
            leftLabel.text = "尚無評論"
            leftLabel.textColor = .B1
            leftLabel.font = .medium(size: 14)
            midLabel.text = "尚無評論"
            midLabel.textColor = .B1
            midLabel.font = .medium(size: 14)
            rightLabel.text = "尚無評論"
            rightLabel.textColor = .B1
            rightLabel.font = .medium(size: 14)
        } else {
            leftLabel.text = String(data[0].ceiling(toDecimal: 1))
            midLabel.text = String(data[1].ceiling(toDecimal: 1))
            rightLabel.text = String(data[2].ceiling(toDecimal: 1))
        }
        
        
    }
    
}
