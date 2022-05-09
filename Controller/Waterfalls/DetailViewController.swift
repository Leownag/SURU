//
//  DetailViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    var account: Account?
    var comment: Comment?
    var store: Store?
//    var name: String?
    var timer = 0
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBAction func tapFollowButton(_ sender: UIButton) {
        
            guard let userID = UserRequestProvider.shared.currentUserID else { return }
            guard let targetID = account?.userID else { return }
        if timer == 0 {
            timer = 1
            AccountRequestProvider.shared.followAccount(currentUserID: userID, tagertUserID: targetID)
        } else {
            timer = 0
            AccountRequestProvider.shared.unfollowAccount(currentUserID: userID, tagertUserID: targetID)
        }
    }
    @IBAction func tapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTopView()
        setuptableView()
    }
    func setupTopView() {
        guard let account = account else {
            return
        }
        let badge = account.badgeStatus ?? "long1"
        badgeImageView.image = UIImage(named: "long_\(badge)")
        authorNameLabel.text = account.name
        authorImageView.kf.setImage(with: URL(string: account.mainImage))
    }
    
    func setuptableView() {
        tableView.register(UINib(nibName: String(describing: CommentCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CommentCell.self))
        
        tableView.register(UINib(nibName: String(describing: CommentStoreCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CommentStoreCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
}
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 675
        } else {
            return 250
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let storeData = store, let commentData = comment else { return UITableViewCell() }
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCell.self), for: indexPath) as? CommentCell else { return UITableViewCell() }
            cell.layoutCell(data: commentData, store: storeData)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentStoreCell.self), for: indexPath) as? CommentStoreCell else { return UITableViewCell() }
            cell.layoutCell(store: storeData)
            cell.delegate = self
            return cell
        }
    }
    
    
}
extension DetailViewController: CommentStoreCellDelegate {
    func didTapCollectStore(_ view: CommentStoreCell, storeID: String) {
        guard let currentUserID = UserRequestProvider.shared.currentUserID else {
            LKProgressHUD.showFailure(text: "你沒有登入喔")
            return
        }
        LKProgressHUD.showSuccess(text: "已收藏")
        
    }
}
