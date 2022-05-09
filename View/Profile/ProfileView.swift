//
//  ProfileView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import UIKit
import Kingfisher

protocol ProfileViewDelegate: AnyObject {
    func didTapAccountButton(_ view: ProfileView)
    func didTapEditProfilebutton(_ view: ProfileView)
    func didTapBadge(_ view: ProfileView)
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    @IBAction func tapEditProfilebutton(_ sender: UIButton) {
        self.delegate?.didTapEditProfilebutton(self)
    }
    
    @IBOutlet weak var tapAccountButton: UIButton!
    @IBAction func tapAccountButton(_ sender: Any) {
        self.delegate?.didTapAccountButton(self)
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var follwersCountLabel: UILabel!
    @IBOutlet weak var follwingCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    var webLink = URL(string: "")
    @objc func linkWeb() {
        guard let webLink = webLink else { return }
        UIApplication.shared.open(webLink)
    }
    func layoutView(account: Account) {
        let web = account.websideLink ?? ""
        
        
        if web != "" {
            webLink = URL(string: web)
            let tap = UITapGestureRecognizer(target: self, action: #selector(linkWeb))
            webLikeImageView.addGestureRecognizer(tap)
            webLikeImageView.isUserInteractionEnabled = true
            webLikeImageView.isHidden = false
        } else {
            webLikeImageView.isHidden = true
        }
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.borderColor = UIColor.B6?.cgColor
        editProfileButton.layer.cornerRadius = 15
        editProfileButton.clipsToBounds = true
        mainImageView.layer.cornerRadius = 40
        mainImageView.clipsToBounds = true
        mainImageView.kf.setImage(with: URL(string: account.mainImage))
        follwersCountLabel.text = String(account.follower.count)
        follwingCountLabel.text = String(account.followedUser.count)
        nameLabel.text = account.name
        bioLabel.text = account.bio
        guard let badge = account.badgeStatus else { return }
        badgeImageView.image = UIImage(named: "long_\(badge)")
        let tap = UITapGestureRecognizer(target: self, action: #selector(initBadge))
        badgeImageView.isUserInteractionEnabled = true
        badgeImageView.addGestureRecognizer(tap)
    }
    @objc func initBadge() {
        self.delegate?.didTapBadge(self)
    }
    @IBOutlet weak var webLikeImageView: UIImageView!
}
