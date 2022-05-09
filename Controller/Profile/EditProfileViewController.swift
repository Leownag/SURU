//
//  EditProfileViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/5.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class EditProfileViewController: UIViewController {
    var mainImage = UIImage()
    var nickName = ""
    var bio = ""
    var webside = ""
    var image = ""
    var badgeTitle = ["登入次數", "發布評論", "回報次數", "收到的喜歡", "追蹤人數"]
    var badgeRef: [[Int]]?
    let editProfileView: EditProfileView = UIView.fromNib()
    var userData: Account? {
        didSet {
            guard let userData = userData else { return }
            editProfileView.layoutView(currentUser: userData)
            self.view.stickSubView(editProfileView)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfileView.delegate = self
//        setupCollectionView()
        settingNavBtn()
        mappingUserData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
//    func setupCollectionView() {
//        editProfileView.collectionView.dataSource = self
//        editProfileView.collectionView.delegate = self
//        let layout = CHTCollectionViewWaterfallLayout()
//        layout.columnCount = 3
//        layout.minimumColumnSpacing = 20
//        layout.minimumInteritemSpacing = 10
//        layout.headerHeight = 100
//        let inset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
//        layout.sectionInset = inset
//        editProfileView.collectionView.collectionViewLayout = layout
//        editProfileView.collectionView.register(UINib(nibName: String(describing: ProfileCommentCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProfileCommentCell.self))
//
//        editProfileView.collectionView.register(UINib(nibName: String(describing: BadgeHeaderCell.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: BadgeHeaderCell.self))
//    }
    func settingNavBtn() {
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancel))
        leftItem.tintColor = .B2
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(save))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
    }
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
        LKProgressHUD.showSuccess(text: "取消編輯")
    }
    func mappingUserData() {
        guard let userData = userData else { return }
        nickName = userData.name
        bio = userData.bio ?? ""
        webside = userData.websideLink ?? ""
        image = userData.mainImage
    }
    @objc func save() {
        guard let userData = userData else { return }
        if image == userData.mainImage {
            let type = ["name", "bio", "websideLink", "mainImage"]
            let content = [self.nickName, self.bio, self.webside, self.image]
            AccountRequestProvider.shared.updateDataAccount(currentUserID: userData.userID, type: type, content: content)
            
            self.dismiss(animated: true) {
                LKProgressHUD.showSuccess(text: "更新成功")
            }
        } else {
            uploadImage {
                let type = ["name", "bio", "websideLink", "mainImage"]
                let content = [self.nickName, self.bio, self.webside, self.image]
                AccountRequestProvider.shared.updateDataAccount(currentUserID: userData.userID, type: type, content: content)
                
                self.dismiss(animated: true) {
                    LKProgressHUD.showSuccess(text: "更新成功")
                }
            }
        }
        
    }
    private func uploadImage(com: @escaping () -> Void) {
        guard let userData = userData else { return }
        guard let image = mainImage.jpegData(compressionQuality: 0.1) else { return }
        let fileName = "\(userData.userID)_\(Date())"
        LKProgressHUD.show()
        FirebaseStorageRequestProvider.shared.postImageToFirebaseStorage(data: image, fileName: fileName) { result in
            switch result {
            case .success(let url) :
                LKProgressHUD.dismiss()
                LKProgressHUD.showSuccess(text: "上傳圖片成功")
                print("上傳圖片成功", url.description)
                self.image = url.description
            case .failure(let error) :
                LKProgressHUD.dismiss()
                LKProgressHUD.showFailure(text: "上傳圖片失敗")
                print("上傳圖片失敗", error)
            }
            com()
        }
    }
    
}
extension EditProfileViewController: EditProfileViewDelegate {
    func didSelectImage(_ view: EditProfileView, image: UIImage) {
        mainImage = image
        LKProgressHUD.showSuccess(text: "刪除成功")
    }
    
    func didTapEditImage(_ view: EditProfileView, alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func didSelectImage(_ view: EditProfileView, image: UIImage, imagePickView: UIImagePickerController) {
        mainImage = image
        imagePickView.dismiss(animated: true) {
            LKProgressHUD.showSuccess(text: "上傳成功")
        }
    }
    
    func didTapImagePicker(_ view: EditProfileView, imagePicker: UIImagePickerController?) {
        guard let imagePicker = imagePicker else { return }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func didEditNickName(_ view: EditProfileView, text: String) {
        nickName = text
//        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "BadgeViewController") as? BadgeViewController else { return }
//        controller.badgeRef = badgeRef
//        controller.seletedBadgeName = userData?.badgeStatus
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didEditWebSide(_ view: EditProfileView, text: String) {
        webside = text
    }
    
    func didEditBio(_ view: EditProfileView, text: String) {
        bio = text
    }
}
//extension EditProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: BadgeHeaderCell.self), for: indexPath) as? BadgeHeaderCell else {
//            return UICollectionReusableView()
//        }
//        cell.titleLabel.text = badgeTitle[indexPath.section]
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        5
//    }
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        5
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileCommentCell.self), for: indexPath) as? ProfileCommentCell, let badgeRef = badgeRef else {
//            return UICollectionViewCell()
//
//        }
//
//        if badgeRef[indexPath.section][indexPath.row] == 0 {
//            cell.mainImageView.kf.setImage(with: URL(string: ""), placeholder: UIImage(named: badgeFile[indexPath.section][indexPath.item])?.withSaturationAdjustment(byVal: 0))
//        } else {
//            cell.mainImageView.kf.setImage(with: URL(string: ""), placeholder: UIImage(named: badgeFile[indexPath.section][indexPath.item]))
//        }
//
//        return cell
//    }
//}

//
//extension EditProfileViewController: CHTCollectionViewDelegateWaterfallLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: 200, height: 200)
//    }
    
    
//}
