//
//  ProfileViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit

class ProfileViewController: UIViewController {

    let profileView: ProfileView = UIView.fromNib()
    var currentUserData: Account?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchUser {
            self.view.stickSubView(self.profileView)
            self.profileView.delegate = self
            self.profileView.layoutView(account: self.currentUserData!)
        }
        
        
        
    }
    func fetchUser(com: @escaping () -> () ) {
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        AccountRequestProvider.shared.fetchAccount(userID: userID) { result in
            switch result {
            case .success(let data):
                self.currentUserData = data
                com()
            case .failure(let error):
                print(error)
                com()
            }
        }
    }
}
extension ProfileViewController: ProfileViewDelegate {
    func didTapLogoutButton(_ view: ProfileView) {
        UserRequestProvider.shared.logOut()
    }
    func didTapDeleteButton(_ view: ProfileView) {
        showAddInfoAlert()
    }
    
    func showAddInfoAlert() {
        let alert = UIAlertController(title: "提示", message: "刪除帳號後資料永久不可復原/n你確定要刪除帳號嗎？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "再想想", style: .default) { _ in
            
        }
        let cancelAction = UIAlertAction(title: "刪除帳號", style: .cancel) { _ in
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
        let submitAction = UIAlertAction(title: "刪除帳號", style: .default) { [unowned alert] _ in
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
