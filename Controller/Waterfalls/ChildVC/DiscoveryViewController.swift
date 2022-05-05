//
//  DiscoveryViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/30.
//

import UIKit
import XLPagerTabStrip
import CHTCollectionViewWaterfallLayout
import Firebase
import FirebaseFirestoreSwift

class DiscoveryViewController: UIViewController {
    //    var subPage: [String] = ["All", "#2019名店", "#2020名店", "#2021名店"]
    var commentData: [Comment] = []
    var currentAccount: Account?
    var storeData: [Store] = []
    var accountData: [Account] = [] 
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        fetchAllData()
        setupCollectionView()
        
//        listenDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.sectionInset = inset
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: String(describing: DiscoveryCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: DiscoveryCell.self))
    }
//    func listenDatabase() {
//            Firestore.firestore().collection("comments").addSnapshotListener { querySnapshot, error in
//                guard let snapshot = querySnapshot else {
//                    print("Error fetching snapshots: \(error!)")
//                    return
//                }
//                snapshot.documentChanges.forEach { diff in
//                    if (diff.type == .added) {
//                        print("New Data ID: \(diff.document.documentID), post title: \(diff.document.data()["title"] ?? "") ")
//                        self.fetchCommentData() {
//                            self.collectionView.reloadData()
//                        }
//                    }
//                }
//            }
//        }
    func fetchCommentData(com: @escaping () -> ()) {
    CommentRequestProvider.shared.fetchComments { result in
        switch result {
        case .success(let data) :
            self.commentData = data
            com()
        case .failure(let error) :
            print("評論頁下載帳號失敗", error)
            com()
        }
    }
    }
    
}

extension DiscoveryViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DiscoveryCell.self)", for: indexPath) as? DiscoveryCell else { return UICollectionViewCell() }
        cell.delegate = self
        if commentData.count != 0 {
        let comment = commentData[indexPath.row]
        let store = storeData.first(where: {$0.storeID == comment.storeID})
        let account = accountData.first(where: {$0.userID == comment.userID})
            if let currentAccount = currentAccount {
        cell.layoutCell(author: account!, comment: comment, currentUser: currentAccount, store: storeData[0])
        }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if commentData.count != 0 {
        let comment = commentData[indexPath.row]
        let store = storeData.first(where: {$0.storeID == comment.storeID})
        let account = accountData.first(where: {$0.userID == comment.userID})
            if let currentAccount = currentAccount {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
                controller.modalPresentationStyle = .fullScreen
                controller.comment = comment
                controller.store = store
                controller.account = account
                self.present(controller, animated: true, completion: nil)
        }
        }
    }
    
}


extension DiscoveryViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        commentData[indexPath.row].contentValue.happiness > 80
        
        let comment = commentData[indexPath.row]
        let store = storeData.first(where: {$0.storeID == comment.storeID})
        let text = "\(store?.name ?? "") - \(comment.meal ?? "")"
        
        if text.count > 12 {
            return CGSize(width: (UIScreen.width - 10 * 3) / 2, height: 300)
        } else {
            return CGSize(width: (UIScreen.width - 10 * 3) / 2, height: 270)
        }
    }
}
extension DiscoveryViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: NSLocalizedString("推薦", comment: "barTagString"))
    }
}
extension DiscoveryViewController {
    func fetchAllData() {
        let group: DispatchGroup = DispatchGroup()
        let concurrentQueue1 = DispatchQueue(label: "com.leowang.queue1", attributes: .concurrent)
        let concurrentQueue2 = DispatchQueue(label: "com.leowang.queue2", attributes: .concurrent)
        let concurrentQueue3 = DispatchQueue(label: "com.leowang.queue3", attributes: .concurrent)
        let concurrentQueue4 = DispatchQueue(label: "com.leowang.queue4", attributes: .concurrent)
        LKProgressHUD.show()
        group.enter()
        concurrentQueue1.async(group: group) {
            AccountRequestProvider.shared.fetchAccounts { result in
                switch result {
                case .success(let data) :
                    print("下載1 全部帳號成功")
                    self.accountData = data
                case .failure(let error) :
                    print("下載1 全部帳號失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載帳號失敗")
                }
                group.leave()
            }
        }
        group.enter()
        guard let currentUser = UserRequestProvider.shared.currentUser else {
            group.leave()
            return
        }
        concurrentQueue2.async(group: group) {
            AccountRequestProvider.shared.fetchAccount(currentUserID: currentUser.uid) { result in
                switch result {
                case .success(let data) :
                    if let data = data {
                        print("下載2 使用者成功")
                        self.currentAccount = data
                    } else {
                        UserRequestProvider.shared.nativePulishToClouldWithAuth(user: currentUser) { result in
                            switch result {
                            case .success:
                                print("下載2 註冊成功")
                            case .failure:
                                LKProgressHUD.dismiss()
                                LKProgressHUD.showFailure(text: "請聯繫客服")
                            }
                        }
                    }
                case .failure(let error) :
                    print("下載2 使用者失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載使用者失敗")
                }
                group.leave()
            }
            
        }
        group.enter()
        concurrentQueue3.async(group: group) {
            StoreRequestProvider.shared.fetchStores { result in
                switch result {
                case .success(let data) :
                    print("下載3 商店資料成功")
                    self.storeData = data
                case .failure(let error) :
                    print("下載3 商店資料失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載商店資料失敗")
                }
                group.leave()
            }
        }
        group.enter()
        concurrentQueue4.async(group: group) {
            CommentRequestProvider.shared.fetchComments { result in
                switch result {
                case .success(let data) :
                    print("下載4 評論成功")
                    self.commentData = data
                case .failure(let error) :
                    print("下載4 評論失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載評論失敗")
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.collectionView.reloadData()
            LKProgressHUD.dismiss()
            LKProgressHUD.showSuccess(text: "下載資料成功")
        }
    }
}

extension DiscoveryViewController: DiscoveryCellDelegate {
    func didTapLikeButton(_ view: DiscoveryCell, comment: Comment) {
        guard let currentUserID = UserRequestProvider.shared.currentUserID else {
            LKProgressHUD.showFailure(text: "你沒有登入喔")
            return
        }
        CommentRequestProvider.shared.likeComment(currentUserID: currentUserID, tagertComment: comment)
    }
    
    func didTapUnLikeButton(_ view: DiscoveryCell, comment: Comment) {
        guard let currentUserID = UserRequestProvider.shared.currentUserID else {
            LKProgressHUD.showFailure(text: "你沒有登入喔")
            return
        }
        CommentRequestProvider.shared.unLikeComment(currentUserID: currentUserID, tagertComment: comment)
    }
    
 
    
    
}