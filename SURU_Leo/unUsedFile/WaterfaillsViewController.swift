//
//  WaterfaillsViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit


class WaterfaillsViewController: UIViewController {
    var accounts: [Account] = []
    var comments: [Comment] = []
    var stores: [Store] = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "評論瀑布牆"
        
        fetchUserData()
        fetchStoreData()
        fetchCommentData() {
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func fetchUserData() {
        AccountRequestProvider.shared.fetchAccounts { result in
            switch result {
            case .success(let data) :
                self.accounts = data
            case .failure(let error) :
                print("評論頁下載帳號失敗", error)
            }
        }
    }
    func fetchStoreData() {
        StoreRequestProvider.shared.fetchStores { result in
            switch result {
            case .success(let data) :
                self.stores = data
                
            case .failure(let error) :
                print("評論頁下載帳號失敗", error)
            }
        }
    }
    func fetchCommentData(com: @escaping () -> ()) {
        CommentRequestProvider.shared.fetchComments { result in
            switch result {
            case .success(let data) :
                self.comments = data
                com()
            case .failure(let error) :
                print("評論頁下載帳號失敗", error)
            }
        }
    }
    func getUserforComment(row: Int) -> Account? {
        for account in accounts where account.userID == comments[row].userID{
            return account
        }
        return accounts.first
    }
    func getStoreforComment(row: Int) -> Store? {
        for store in stores where store.storeID == comments[row].storeID{
            return store
        }
        return stores.first
    }
//    func listenDatabase() {
//        Firestore.firestore().collection("comments").addSnapshotListener { querySnapshot, error in
//            guard let snapshot = querySnapshot else {
//                print("Error fetching snapshots: \(error!)")
//                return
//            }
//            snapshot.documentChanges.forEach { diff in
//                if (diff.type == .added) {
//                    print("New Data ID: \(diff.document.documentID), post title: \(diff.document.data()["title"] ?? "") ")
//                    self.fetchCommentData() {
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }
//    }
}
extension WaterfaillsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SampleCommentCell") as? SampleCommentCellTableViewCell else { return UITableViewCell()}
        let comment = comments[indexPath.row]
        let user = getUserforComment(row: indexPath.row)
        let store = getStoreforComment(row: indexPath.row)
        
        cell.layoutSampleCommentCell(store: store, comment: comment, account: user)
        return cell
    }
    
}
