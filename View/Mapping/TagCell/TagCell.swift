//
//  TagCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/6.
//

import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var tagButton: UIButton! {
        didSet {
            tagButton.layer.cornerRadius = 10
            tagButton.clipsToBounds = true
            tagButton.backgroundColor = .white
            tagButton.isUserInteractionEnabled = false
            tagButton.titleEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 2, right: 2)
            
        }
    }

}
