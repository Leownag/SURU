//
//  StorePageViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import UIKit

class StorePageViewController: UIViewController {

    var commentData: [Comment] = []
    var storeData: Store?
    var currentUser: Account?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hidesBottomBarWhenPushed = true
        tableView.dataSource = self
        tableView.delegate = self
        registeCell()
//        tableView.backgroundColor = .C4
        
        navigationController?.navigationBar.tintColor = .B1
//        view.backgroundColor = .C4
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    func registeCell() {
        tableView.lk_registerCellWithNib(identifier: StoreTitleCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreImageCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreTagsCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreLocaltionCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreOpenTimeCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreSeatsCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreRatingCell.identifier, bundle: nil)
    }


}
extension StorePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else {
            return commentData.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let storeData = storeData else { return UITableViewCell() }
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreTitleCell.identifier, for: indexPath) as? StoreTitleCell else { return UITableViewCell() }
                cell.delegate = self
                guard let user = currentUser else { return cell}
                let isCollect = user.collectedStore.contains(storeData.storeID)
                cell.layoutCell(store: storeData, isCollect: isCollect)
                
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreImageCell.identifier, for: indexPath) as? StoreImageCell else { return UITableViewCell() }
                let sortedComment = commentData.sorted(by: {$0.likedUserList.count > $1.likedUserList.count})
                if sortedComment.count > 3 {
                    cell.layoutCell(popular: sortedComment[0].mainImage, menu: sortedComment[1].mainImage, more: sortedComment.randomElement()?.mainImage)
                } else {
                    cell.layoutCell(popular: "AppIcon", menu: "AppIcon", more: "AppIcon")
                }
                cell.delegate = self
                
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreTagsCell.identifier, for: indexPath) as? StoreTagsCell else { return UITableViewCell() }
                cell.collectionView.register(UINib(nibName: String(describing: TagsCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: TagsCell.self))
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                let layout = TagFlowLayout()
                layout.estimatedItemSize = CGSize(width: 140, height: 40)
                cell.collectionView.collectionViewLayout = layout
//                cell.collectionView.collectionViewLayout.
                
                
                return cell
            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreLocaltionCell.identifier, for: indexPath) as? StoreLocaltionCell else { return UITableViewCell() }
                cell.layoutCell(localtion: storeData.address)
                
                return cell
            case 4:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreOpenTimeCell.identifier, for: indexPath) as? StoreOpenTimeCell else { return UITableViewCell() }
                cell.layoutCell(openTime: storeData.opentime)
                
                return cell
            case 5:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreLocaltionCell.identifier, for: indexPath) as? StoreLocaltionCell else { return UITableViewCell() }
                cell.layoutCell(seat: storeData.seat)
                
                return cell
            case 6:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreRatingCell.identifier, for: indexPath) as? StoreRatingCell else { return UITableViewCell() }
                var soup: Double = 0
                var noodle: Double = 0
                var happy: Double = 0
                for comment in commentData {
                    soup += comment.contentValue.soup
                    noodle += comment.contentValue.noodle
                    happy += comment.contentValue.happiness
                }
                let count = Double(commentData.count)
                let data = [soup/count, noodle/count, happy/count]
                cell.layoutCell(data: data)
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                
                return 80
            case 1:
               
                return UIScreen.width/1.5 - 20
            case 2:
                
                return 50
            case 3:
                
                return 50
            case 4:
                
                return 50
            case 5:
               
                return 50
            case 6:
                return 200
            default:
                return 200
            }
        } else {
            return 200
        }
    }
}
extension StorePageViewController: StoreTitleCellDelegate {
    func didtapUnCollectionButton(view: StoreTitleCell) {
        guard let user = currentUser, let store = storeData else { return }
        StoreRequestProvider.shared.unCollectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
            switch result {
            case .success(let message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "更新失敗")
            }
        }
    }
    
    func didtapCollectionButton(view: StoreTitleCell) {
        guard let user = currentUser, let store = storeData else { return }
        StoreRequestProvider.shared.collectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
            switch result {
            case .success(let message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "更新失敗")
            }
        }
    }
}
extension StorePageViewController: StoreImageCellDelegate {
    func didTapPopularImage(_ view: StoreImageCell, image: UIImage) {
        let view: fullScreenImageView = UIView.fromNib()
        view.imageView.image = image
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmiss))
        view.addGestureRecognizer(tap)
        self.view.stickSubView(view)
        
        print("didTapPopularImage")
    }
    
    func didTapmenuImage(_ view: StoreImageCell, image: UIImage) {
        print("didTapmenuImage")
    }
    
    func didTapmoreImage(_ view: StoreImageCell, image: UIImage) {
        print("didTapmoreImage")
    }
    @objc func dissmiss(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
}
extension StorePageViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let storeData = storeData else { return 0 }
        return storeData.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagsCell.self),
                                                            for: indexPath) as? TagsCell else { return TagsCell() }
        guard let storeData = storeData else { return TagsCell() }
        cell.tagLabel.text = storeData.tags[indexPath.row]
        cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width
        
        cell.backgroundColor = .C4
        
        
        return cell
    }
}
