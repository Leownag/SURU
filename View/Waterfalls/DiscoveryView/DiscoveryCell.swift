//
//  DiscoveryCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/1.
//

import UIKit
import Kingfisher

protocol DiscoveryCellDelegate: AnyObject {
    func didTapLikeButton(_ view: DiscoveryCell)
}

class DiscoveryCell: UICollectionViewCell {
    weak var delegate: DiscoveryCellDelegate?
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBAction func tapLikeButton(_ sender: UIButton) {
        if likeButton.tintColor == .systemRed {
            likeButton.tintColor = .B5
        } else {
            likeButton.tintColor = .systemRed
        }
        self.delegate?.didTapLikeButton(self)
    }
    
    
    func layoutCell(author: Account, comment: Comment, currentUser: Account, store: Store) {
        mainImageView.kf.setImage(with: URL(string: comment.mainImage))
            nameLabel.text = "\(store.name) -\n\(comment.meal)"
            authorImageView.kf.setImage(with: URL(string: author.mainImage))
            authorNameLabel.text = author.name
        
        likeButton.titleLabel?.text = String(comment.likedUserList.count)
//        if currentUser.likedComment.contains(where: { $0.likeComment == comment.commentID}) {
//            likeButton.isSelected = true
//        } else {
//            likeButton.isSelected = false
//        }
                                  
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //配置点赞按钮被选中时的样式
        self.layer.borderColor = UIColor.B5?.cgColor
        self.layer.borderWidth = 0.5
//        let icon = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
//        likeButton.setImage(icon, for: .selected)
        
    }
    
}
