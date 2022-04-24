//
//  SendCommentConmViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/17.
//

import UIKit
import SwiftUI

class CommentViewController: UIViewController {
    // View
    let startingView = CommentStartingView()
    
    let imageCardView = CommentImageCardView()
    
    let selectionView = CommentSelectionView()
    
    // datasource放置
    var stores: [Store] = []
    var comments: [Comment] = []
    var commentDrafts: [CommentDraft] = []
    
    var commentData: Comment = {
        let comment = Comment(
        userID: "ZBrsbRumZjvowPKfpFZL",
        storeID: "",
        meal: "",
        contentValue: CommentContent(happiness: 0, noodle: 0, soup: 0),
        contenText: "",
        mainImage: "")
        return comment
    }()
    
    // 上傳前的照片
    var imageDataHolder: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startingView.commentTableView?.register(UINib(nibName: String(describing: CommentTableViewCell.self), bundle: nil), forCellReuseIdentifier: "CommentsCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStoreData()
        fetchCoreData {
            
        }
        fetchCommentOfUser {
            self.setupStartingView()
        }
        
    }
    
    func fetchStoreData() {
        StoreRequestProvider.shared.fetchStores { result in
            switch result {
            case .success(let data):
                self.stores = data
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchCommentOfUser(com: @escaping () -> Void) {
        CommentRequestProvider.shared.fetchCommentsOfUser(useID: "ZBrsbRumZjvowPKfpFZL") { result in
            switch result {
            case .success(let data):
                self.comments = data
                com()
            case .failure(let error):
                print(error)
                com()
            }
        }
    }
    func fetchCoreData(com: @escaping () -> Void) {
        StorageManager.shared.fetchComments { result in
            switch result {
            case .success(let data):
                self.commentDrafts = data
                com()
            case .failure(let error):
                print(error)
                com()
            }
        }
    }
    
    func setupStartingView() {
        self.view.addSubview(startingView)
        startingView.translatesAutoresizingMaskIntoConstraints = false
        startingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        startingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        startingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        startingView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        startingView.commentTableView?.isHidden = false
        startingView.commentTableView?.delegate = self
        startingView.commentTableView?.dataSource = self
        startingView.delegate = self
        startingView.layoutStartingView()
    }
    
    func setupImageCardView(_ image: UIImage) {
        self.view.addSubview(imageCardView)
        imageCardView.translatesAutoresizingMaskIntoConstraints = false
        imageCardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        imageCardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        imageCardView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        imageCardView.heightAnchor.constraint(equalTo: imageCardView.widthAnchor, multiplier: 5 / 4).isActive = true
        imageCardView.delegate = self
        imageCardView.layoutCommendCardView(image: image) { [weak self] in
            guard let self = self else { return }
            self.setupCommentSelectionView()
        }
    }
    
    func setupCommentSelectionView() {
        self.view.addSubview(selectionView)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        selectionView.delegate = self
        selectionView.backgroundColor = .C2
        selectionView.topAnchor.constraint(equalTo: self.imageCardView.bottomAnchor, constant: -50).isActive = true
        selectionView.leadingAnchor.constraint(equalTo: self.imageCardView.leadingAnchor).isActive = true
        selectionView.trailingAnchor.constraint(equalTo: self.imageCardView.trailingAnchor).isActive = true
        selectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        selectionView.layoutSelectView(dataSource: stores)
    }
    
//    func setupDraggingView(_ type: SelectionType) {
//        let draggingView = CommentDraggingView()
//        view.addSubview(draggingView)
//        draggingView.delegate = self
//        draggingView.translatesAutoresizingMaskIntoConstraints = false
//
//        draggingView.frame = CGRect(x: -300, y: 0, width: 300, height: UIScreen.height)
//        draggingView.layoutDraggingView(type: type)
//        UIView.animate(withDuration: 0.5) {
//            draggingView.frame = CGRect(x: 0, y: 0, width: 300, height: UIScreen.height)
//        }
//    }
    func setupDraggingView(_ type: SelectionType) {
        let controller = DragingValueViewController()
        controller.liquilBarview.delegate = self
        controller.delegate = self
        self.addChild(controller)
        view.addSubview(controller.view)
        controller.view.backgroundColor = UIColor.C5
        controller.view.frame = CGRect(x: -300, y: 0, width: 300, height: UIScreen.main.bounds.height)
        controller.view.corner(byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radii: 30)
        controller.setupLayout(type)
        UIView.animate(withDuration: 0.5) {
            self.tabBarController?.tabBar.isHidden = true
            controller.view.frame = CGRect(x: 0, y: 0, width: 300, height: UIScreen.main.bounds.height)
        }
    }

    func publishComment() {
        CommentRequestProvider.shared.publishComment(comment: &commentData) { result in
            switch result {
            case .success(let message):
                print("上傳評論成功", message)
            case .failure(let error):
                print("上傳評論失敗", error)
            }
        }
    }
}

// StartingView Delegate
extension CommentViewController: CommentStartingViewDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func didTapImageView(_ view: CommentStartingView, imagePicker: UIImagePickerController?) {
        guard let imagePicker = imagePicker else {
            return
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func didFinishPickImage(_ view: CommentStartingView, imagePicker: UIImagePickerController, image: UIImage) {
        setupImageCardView(image)
        imageDataHolder = image.jpegData(compressionQuality: 0.1) ?? Data()
        imagePicker.dismiss(animated: true) {
            view.removeFromSuperview()
        }
    }
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return comments.count
        } else {
            return commentDrafts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.layoutCommentCell(data: comments[indexPath.row])
            return cell
        } else {
            cell.layoutDraftCell(data: commentDrafts[indexPath.row])
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "你的評論草稿"
        } else {
            return "你發表過的評論"
        }
    }
}

// CommentImageCardView Delegate
extension CommentViewController: CommentImageCardViewDelegate {
    func didFinishPickImage(_ view: CommentImageCardView, imagePicker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func didTapImageView(_ view: CommentImageCardView) {
        guard let imagePicker = view.imagePicker else { return }
        present(imagePicker, animated: true, completion: nil)
    }
}

extension CommentViewController: CommentSelectionViewDelegate {
    func didGetSelectStore(_ view: CommentSelectionView, storeID: String) {
        print("didTapSelectNoodleValue")
    }
    
    func didGetSelectMeal(_ view: CommentSelectionView, meal: String) {
        print("didTapSelectNoodleValue")
    }
    

    func didTapSelectValue(_ view: CommentSelectionView, type: SelectionType) {
        setupDraggingView(type)
    }
    
    
    func didTapWriteComment(_ view: CommentSelectionView) {
        print("didTapWriteComment")
    }
    
    func didTapNotWriteComment(_ view: CommentSelectionView) {
        print("didTapNotWriteComment")
    }
    
    func didTapSendComment(_ view: CommentSelectionView) {
        guard let image = imageDataHolder else { return }
        let fileName = "\(commentData.userID)_\(Date())"
        FirebaseStorageRequestProvider.shared.postImageToFirebaseStorage(data: image, fileName: fileName) { result in
            switch result {
            case .success(let url) :
                print("上傳圖片成功", url.description)
                self.commentData.mainImage = url.description
                self.publishComment()
            case .failure(let error) :
                print("上傳圖片失敗", error)
            }
        }
    }
    
    func didTapSaveComment(_ view: CommentSelectionView) {
        print("didTapSaveComment")
    }
    
    func didTapDownloadImage(_ view: CommentSelectionView) {
        print("didTapDownloadImage")
    }
    
    func didTapAddoneMore(_ view: CommentSelectionView) {
        print("didTapAddoneMore")
    }
    
    func didTapGoAllPage(_ view: CommentSelectionView) {
        print("didTapGoAllPage")
    }
}


extension CommentViewController: CommentDraggingViewDelegate {
    func didTapBackButton(vc: DragingValueViewController) {
        UIView.animate(withDuration: 0.5) {
            vc.view.frame = CGRect(x: -300, y: 0, width: 300, height: UIScreen.main.bounds.height)
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}
extension CommentViewController: LiquidViewDelegate {
    func didGetSelectionValue(view: LiquidBarViewController, type: SelectionType, value: Double) {
        switch type {
        case .noodle:
            commentData.contentValue.noodle = value
        case .soup:
            commentData.contentValue.soup = value
        case .happy:
            commentData.contentValue.happiness = value
        }
    }
}

