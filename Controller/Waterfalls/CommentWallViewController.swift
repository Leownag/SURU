//
//  CommentWallViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/30.
//

import UIKit
import XLPagerTabStrip


class CommentWallViewController: ButtonBarPagerTabStripViewController {
    //    var subVC: [String] = ["Discovery", "Collect", "Follow"]
    
    var accounts: [Account] = []
    var comments: [Comment] = []
    var stores: [Store] = []
    var currentAccount: Account?
    
    override func viewDidLoad() {

        settings.style.selectedBarBackgroundColor = .white
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemLeftRightMargin = 0

        super.viewDidLoad()
        
        containerView.bounces = false
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
        

    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let discoveryVC = storyboard.instantiateViewController(identifier: "DiscoveryViewController") as! DiscoveryViewController
//        let disVC = storyboard.instantiateViewController(identifier: "DiscoveryViewController") as! DiscoveryViewController
//        let triVC = storyboard.instantiateViewController(identifier: "DiscoveryViewController") as! DiscoveryViewController
//        discoveryVC.view.isHidden = true
        fetchData {
            discoveryVC.currentAccount = self.currentAccount
            discoveryVC.storeData = self.stores
            discoveryVC.accountData = self.accounts
            discoveryVC.commentData = self.comments
            
        }
        return[discoveryVC]
    }
    
    
}
// firebase
extension CommentWallViewController {
    
    func fetchData(com: @escaping () -> ()) {
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
                    self.accounts = data
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
                    self.stores = data
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
                    self.comments = data
                    group.leave()
                case .failure(let error) :
                    print("評論頁下載帳號失敗", error)
                    group.leave()
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {
            
            print("完成所有 Call 後端 API 的動作...")
            com()
        }
    }
}
