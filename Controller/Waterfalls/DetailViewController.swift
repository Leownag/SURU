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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBAction func tapFollowButton(_ sender: Any) {
        let alert = UIAlertController(title: "提示", message: "已追蹤用戶： \(account!.name)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好", style: .default) { _ in
           print("去個人頁面")
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
            return 600
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
//        LKProgressHUD.showSuccess(text: "已收藏")
        let alert = UIAlertController(title: "提示", message: "已收藏店家： \(store!.name)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好", style: .default) { _ in
           print("去個人頁面")
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
