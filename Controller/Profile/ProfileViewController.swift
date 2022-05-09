//
//  ProfileViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class ProfileViewController: UIViewController {
    
    let profileView: ProfileView = UIView.fromNib()
    var currentUserData: Account?
    var currentUserComment: [Comment]?
    var badgeRef: [[Int]]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SURU檔案"
        addlistener()
        fetchData {
            guard let currentUserData = self.currentUserData else {return}
            self.checkUserStatus()
            self.view.stickSubView(self.profileView)
            self.setupCollectionView()
            
            self.profileView.delegate = self
            self.profileView.layoutView(account: currentUserData)
        }
        
    }
    func addlistener() {
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        AccountRequestProvider.shared.listenAccount(currentUserID: userID) {
            self.fetchAccount(userID: userID)
        }
    }
    func setupCollectionView() {
        profileView.collectionView.dataSource = self
        profileView.collectionView.delegate = self
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 3
        layout.minimumColumnSpacing = 3
        layout.minimumInteritemSpacing = 3
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.sectionInset = inset
        profileView.collectionView.collectionViewLayout = layout
        profileView.collectionView.register(UINib(nibName: String(describing: ProfileCommentCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProfileCommentCell.self))
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let comment = currentUserComment else { return 0 }
        if comment.isEmpty {
            collectionView.setEmptyMessage("你還沒有發表過評論喔！")
        } else {
            collectionView.restore()
        }
        return comment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileCommentCell.self), for: indexPath) as? ProfileCommentCell else {
            return UICollectionViewCell()
        }
        guard let comment = currentUserComment else { return cell }
        cell.layoutCell(comment: comment[indexPath.item])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.width - 3 * 2
        
        return CGSize(width: width, height: width)
    }
}
extension ProfileViewController: ProfileViewDelegate {
    func didTapBadge(_ view: ProfileView) {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "BadgeViewController") as? BadgeViewController else { return }
        guard let currentUserData = currentUserData else { return }
        controller.badgeRef = badgeRef
        controller.seletedBadgeName = currentUserData.badgeStatus
                navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapEditProfilebutton(_ view: ProfileView) {
        showEditingPage()
    }
    
    func didTapAccountButton(_ view: ProfileView) {
        showAlert()
    }
    func showEditingPage() {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else { return }
        guard let userData = currentUserData else { return }
        controller.userData = userData
        controller.badgeRef = badgeRef
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "登出帳號", style: .default , handler:{ (UIAlertAction) in
            UserRequestProvider.shared.logOut()
            LKProgressHUD.showSuccess(text: "登出成功")
        }))
        
        alert.addAction(UIAlertAction(title: "刪除帳號", style: .destructive , handler:{ (UIAlertAction) in
            self.showDestructiveAlert()
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    func showDestructiveAlert() {
        let alert = UIAlertController(title: "提示", message: "刪除帳號後資料永久不可復原，你確定要刪除帳號嗎？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "再想想", style: .default) { _ in
            
        }
        let cancelAction = UIAlertAction(title: "刪除帳號", style: .destructive) { _ in
            self.showAuthAlert()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func showAuthAlert() {
        let alert = UIAlertController(title: "輸入密碼", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.textFields![0].isSecureTextEntry = true
        let submitAction = UIAlertAction(title: "刪除帳號", style: .destructive) { [unowned alert] _ in
            guard let password = alert.textFields![0].text else { return }
            self.deleteAccount(password: password)
        }
        let okAction = UIAlertAction(title: "再想想", style: .cancel) { _ in
        }
        
        alert.addAction(submitAction)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    func deleteAccount(password: String) {
        guard let userID = UserRequestProvider.shared.currentUserID else {
            LKProgressHUD.showFailure(text: "刪除失敗 稍後再試")
            return
        }
        UserRequestProvider.shared.nativeDeleteAccount(password: password) { result in
            switch result {
            case .failure(let error):
                print("刪除失敗 稍後再試",error)
                LKProgressHUD.showFailure(text: error.localizedDescription)
            case .success(let message):
                self.deleteUserInfo(userID: userID)
                LKProgressHUD.showSuccess(text: message)
            }
        }
    }
    func deleteUserInfo(userID: String) {
        AccountRequestProvider.shared.deleteAccountInfo(userID: userID) { result in
            switch result {
            case .failure(let error):
                print("個人頁面刪除帳號資料庫失敗", error)
            case .success(let message):
                print("個人頁面刪除帳號資料庫成功", message)
            }
        }
    }
}
extension ProfileViewController {
    func fetchData(competion: @escaping () -> Void) {
        let group: DispatchGroup = DispatchGroup()
        let concurrentQueue1 = DispatchQueue(label: "com.leowang.queue1", attributes: .concurrent)
        let concurrentQueue2 = DispatchQueue(label: "com.leowang.queue2", attributes: .concurrent)
        LKProgressHUD.show(text: "讀取使用者資訊中")
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        group.enter()
        concurrentQueue1.async(group: group) {
            AccountRequestProvider.shared.fetchAccount(currentUserID: userID) { result in
                switch result {
                case .success(let data):
                    print("下載用戶成功")
                    self.currentUserData = data
                case .failure(let error):
                    print("下載用戶失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載用戶失敗")
                }
                group.leave()
            }
            
        }
        group.enter()
        concurrentQueue2.async(group: group) {
            CommentRequestProvider.shared.fetchCommentsOfUser(useID: userID) { result in
                switch result {
                case .success(let data) :
                    print("下載用戶評論成功")
                    self.currentUserComment = data
                case .failure(let error) :
                    print("下載用戶評論失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載評論失敗")
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            LKProgressHUD.dismiss()
            competion()
        }
    }
    func fetchAccount(userID: String) {
        AccountRequestProvider.shared.fetchAccount(currentUserID: userID) { result in
            switch result {
            case .success(let data):
                print("下載用戶成功")
                
                self.currentUserData = data
                guard let currentUserData = self.currentUserData else { return }
                
                self.profileView.layoutView(account: currentUserData)
                self.profileView.collectionView.reloadData()
            case .failure(let error):
                print("下載用戶失敗", error)
            }
        }
    }
}

extension ProfileViewController {
    func checkUserStatus() {
        var ref: [[Int]] = [[], [], [], [], []]
        guard let user = currentUserData else { return }
        let followerCount = user.follower.count
        let loginCount = user.loginHistory?.count ?? 0
        let publishCommentCount = user.commentCount
        let publishReportCount = user.sendReportCount ?? 0
        let likeCount = user.myCommentLike ?? 0
       
        if  loginCount >= 30 {
            ref[0] = [1, 1, 1, 1, 1]
        } else if loginCount >= 15 {
            ref[0] = [1, 1, 1, 1, 0]
        } else if loginCount >= 7 {
            ref[0] = [1, 1, 1, 0, 0]
        } else if loginCount >= 3 {
            ref[0] = [1, 1, 0, 0, 0]
        } else if loginCount >= 1 {
            ref[0] = [1, 0, 0, 0, 0]
        } else {
            ref[0] = [0, 0, 0, 0, 0]
        }
        if  likeCount >= 200 {
            ref[3] = [1, 1, 1, 1, 1]
        } else if likeCount >= 100 {
            ref[3] = [1, 1, 1, 1, 0]
        } else if likeCount >= 50 {
            ref[3] = [1, 1, 1, 0, 0]
        } else if likeCount >= 30 {
            ref[3] = [1, 1, 0, 0, 0]
        } else if likeCount >= 10 {
            ref[3] = [1, 0, 0, 0, 0]
        } else {
            ref[3] = [0, 0, 0, 0, 0]
        }
        if  publishCommentCount >= 30 {
            ref[1] = [1, 1, 1, 1, 1]
        } else if publishCommentCount >= 20 {
            ref[1] = [1, 1, 1, 1, 0]
        } else if publishCommentCount >= 10 {
            ref[1] = [1, 1, 1, 0, 0]
        } else if publishCommentCount >= 5 {
            ref[1] = [1, 1, 0, 0, 0]
        } else if publishCommentCount >= 1 {
            ref[1] = [1, 0, 0, 0, 0]
        } else {
            ref[1] = [0, 0, 0, 0, 0]
        }
        if  followerCount >= 50 {
            ref[4] = [1, 1, 1, 1, 1]
        } else if followerCount >= 30 {
            ref[4] = [1, 1, 1, 1, 0]
        } else if followerCount >= 20 {
            ref[4] = [1, 1, 1, 0, 0]
        } else if followerCount >= 10 {
            ref[4] = [1, 1, 0, 0, 0]
        } else if followerCount >= 5 {
            ref[4] = [1, 0, 0, 0, 0]
        } else {
            ref[4] = [0, 0, 0, 0, 0]
        }
        if  publishReportCount >= 20 {
            ref[2] = [1, 1, 1, 1, 1]
        } else if publishReportCount >= 15 {
            ref[2] = [1, 1, 1, 1, 0]
        } else if publishReportCount >= 10 {
            ref[2] = [1, 1, 1, 0, 0]
        } else if publishReportCount >= 5 {
            ref[2] = [1, 1, 0, 0, 0]
        } else if publishReportCount >= 1 {
            ref[2] = [1, 0, 0, 0, 0]
        } else {
            ref[2] = [0, 0, 0, 0, 0]
        }
        badgeRef = ref
    }
}
