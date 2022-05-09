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
        setupCollectionView()
        listenDatabase()
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
    func listenDatabase() {
            Firestore.firestore().collection("comments").addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        print("New Data ID: \(diff.document.documentID), post title: \(diff.document.data()["title"] ?? "") ")
                        self.fetchCommentData() {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
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
    func fetchDataAndPresentInSameTime() {
        let group: DispatchGroup = DispatchGroup()
        let concurrentQueue1 = DispatchQueue(label: "com.leowang.queue1", attributes: .concurrent)
        let concurrentQueue2 = DispatchQueue(label: "com.leowang.queue2", attributes: .concurrent)
        let concurrentQueue3 = DispatchQueue(label: "com.leowang.queue3", attributes: .concurrent)
        let concurrentQueue4 = DispatchQueue(label: "com.leowang.queue4", attributes: .concurrent)
        
        group.enter()
        concurrentQueue1.async(group: group) {
            AccountRequestProvider.shared.fetchAccounts { result in
                switch result {
                case .success(let data) :
                    self.accountData = data
                    group.leave()
                case .failure(let error) :
                    print("評論頁下載帳號失敗", error)
                    group.leave()
                }
            }
        }
        group.enter()
        concurrentQueue2.async(group: group) {
            guard let user = UserRequestProvider.shared.firebaseAuth.currentUser else { return }
            AccountRequestProvider.shared.fetchAccount(userID: user.uid) { result in
                switch result {
                case .success(let data) :
                    self.currentAccount = data
                    group.leave()
                case .failure(let error) :
                    print("評論頁下載帳號失敗", error)
                    group.leave()
                }
            }
            
        }
        group.enter()
        concurrentQueue3.async(group: group) {
            StoreRequestProvider.shared.fetchStores { result in
                switch result {
                case .success(let data) :
                    self.storeData = data
                    group.leave()
                case .failure(let error) :
                    print("評論頁下載帳號失敗", error)
                    group.leave()
                }
            }
        }
        group.enter()
        concurrentQueue4.async(group: group) {
            CommentRequestProvider.shared.fetchComments { result in
                switch result {
                case .success(let data) :
                    self.commentData = data
                    group.leave()
                case .failure(let error) :
                    print("評論頁下載帳號失敗", error)
                    group.leave()
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.collectionView.reloadData()
            print("完成所有 Call 後端 API 的動作...")
        }
    }
}

extension DiscoveryViewController: DiscoveryCellDelegate {
    func didTapLikeButton(_ view: DiscoveryCell) {
        print("Like")
    }
    
    
}
