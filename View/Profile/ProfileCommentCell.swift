//
//  ProfileCommentCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/6.
//

import UIKit
import Kingfisher

class ProfileCommentCell: UICollectionViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func layoutCell (comment: Comment) {
        mainImageView.loadImage(comment.mainImage, placeHolder: nil)
    }
}
