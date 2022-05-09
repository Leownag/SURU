//
//  StoreImageCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import UIKit
import Kingfisher

protocol StoreImageCellDelegate: AnyObject{
    func didTapPopularImage(_ view: StoreImageCell, image: UIImage)
    func didTapmenuImage(_ view: StoreImageCell, image: UIImage)
    func didTapmoreImage(_ view: StoreImageCell, image: UIImage)
}
class StoreImageCell: UITableViewCell {
    weak var delegate: StoreImageCellDelegate?
    @IBOutlet weak var popularImageView: UIImageView!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var moreBlurView: UIView!
    
    func layoutCell(popular: String?, menu: String?, more: String?) {
        guard let popular = popular, let more = more, let menu = menu else {
            return
        }
        popularImageView.kf.setImage(with: URL(string: popular), placeholder: UIImage(named: "man\(Int.random(in: 1..<8))"))
        menuImageView.kf.setImage(with: URL(string: menu), placeholder: UIImage(named: "man\(Int.random(in: 1..<8))"))
        moreImageView.kf.setImage(with: URL(string: more), placeholder: UIImage(named: "man\(Int.random(in: 1..<8))"))
        let tapPopular = UITapGestureRecognizer(target: self, action: #selector(didTapPopularImage))
        let tapMenu = UITapGestureRecognizer(target: self, action: #selector(didTapmenuImage))
        let tapMore = UITapGestureRecognizer(target: self, action: #selector(didTapmoreImage))
        
        popularImageView.addGestureRecognizer(tapPopular)
        menuImageView.addGestureRecognizer(tapMenu)
        moreBlurView.addGestureRecognizer(tapMore)
        popularImageView.isUserInteractionEnabled = true
        menuImageView.isUserInteractionEnabled = true
        moreImageView.isUserInteractionEnabled = true
    }
    
    
    
    @objc func didTapPopularImage() {
        guard let image = popularImageView.image else { return }
        self.delegate?.didTapPopularImage(self, image: image)
    }
    @objc func didTapmenuImage() {
        guard let image = menuImageView.image else { return }
        self.delegate?.didTapmenuImage(self, image: image)
    }
    @objc func didTapmoreImage() {
        guard let image = moreImageView.image else { return }
        self.delegate?.didTapmoreImage(self, image: image)
    }
}
