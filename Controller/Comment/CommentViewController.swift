//
//  SendCommentConmViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/17.
//

import UIKit
//import SwiftUI

class CommentViewController: UIViewController {
    // View
    let startingView = CommentStartingView()
    
    let imageCardView = CommentImageCardView()
    
    let selectionView = CommentSelectionView()
    
    // datasource放置
    var orderObserver: NSKeyValueObservation!
    var stores: [Store] = []
    var comments: [Comment] = []
    var commentDrafts: [CommentDraft] = []
    let userID = UserRequestProvider.shared.currentUserID
    var commentData: Comment = Comment(
        userID: "",
        storeID: "",
        meal: "",
        contentValue: CommentContent(happiness: 0, noodle: 0, soup: 0),
        contenText: "",
        mainImage: "")
        
    
    
    // 上傳前的照片
    var imageDataHolder: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userID != nil {
        commentData.userID = userID!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingKVO()
        fetchStoreData()
        fetchCoreData {
        }
        fetchCommentOfUser {
            self.setupStartingView()
        }
        
    }
    
    func settingKVO() {
        orderObserver = StorageManager.shared.observe(
            \StorageManager.comments,
            options: .new,
            changeHandler: { [weak self] _, change in
          
                self!.startingView.commentTableView.reloadSections([1], with: .none)
               
            }
        )
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
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        CommentRequestProvider.shared.fetchCommentsOfUser(useID: userID) { result in
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
        startingView.commentTableView.isHidden = false
        startingView.commentTableView.delegate = self
        startingView.commentTableView.dataSource = self
        startingView.commentTableView.allowsSelection = true
        startingView.commentTableView.isUserInteractionEnabled = true
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
        self.view.insertSubview(selectionView, belowSubview: imageCardView)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        selectionView.delegate = self
        selectionView.backgroundColor = .B6
        selectionView.topAnchor.constraint(equalTo: self.imageCardView.bottomAnchor, constant: 10).isActive = true
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
        controller.view.backgroundColor = UIColor.B5
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
                LKProgressHUD.showSuccess(text: "上傳評論成功")
                self.fetchCommentOfUser {
                    self.setupStartingView()
                    
                }
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
        if section == 1 {
            return comments.count
        } else {
            return commentDrafts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentTableViewCell.self), for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        if indexPath.section == 1 {
            let name = stores.first(where: {$0.storeID == comments[indexPath.row].storeID})?.name
            cell.layoutCommentCell(data: comments[indexPath.row], name: name ?? "未輸入店名")
            return cell
        } else {
            let name = stores.first(where: {$0.storeID == comments[indexPath.row].storeID})?.name
            cell.layoutDraftCell(data: commentDrafts[indexPath.row], name: name ?? "未輸入店名")
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            setupImageCardView(UIImage(data: commentDrafts[indexPath.row].image!)!)
            startingView.removeFromSuperview()
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
        commentData.storeID = storeID
    }
    
    func didGetSelectMeal(_ view: CommentSelectionView, meal: String) {
        commentData.meal = meal
    }
    

    func didTapSelectValue(_ view: CommentSelectionView, type: SelectionType) {
        setupDraggingView(type)
    }
    
    
    func didTapWriteComment(_ view: CommentSelectionView) {
        preSentWriteCommentView()
    }
    
    func didTapNotWriteComment(_ view: CommentSelectionView) {
        preSentWriteCommentView()
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
        StorageManager.shared.addDraftComment(comment: commentData, image: imageDataHolder!) { result in
            switch result {
            case .success(let data):
                    print("Coredata")
            case .failure(let error):
                print(error)
            }
        }
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
            self.imageCardView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        }
    }
}
extension CommentViewController: LiquidViewDelegate {
    func didGetSelectionValue(view: LiquidBarViewController, type: SelectionType, value: Double) {
        switch type {
        case .noodle:
            commentData.contentValue.noodle = value
            initValueView(on: selectionView.selectNoodelValueButton, value: value,color: UIColor.systemYellow.cgColor)
            
        case .soup:
            commentData.contentValue.soup = value
            initValueView(on: selectionView.selectSouplValueButton, value: value,color: UIColor.systemBlue.cgColor)
            
        case .happy:
            commentData.contentValue.happiness = value
            initValueView(on: selectionView.selectHappyValueButton, value: value,color: UIColor.systemPink.cgColor)
            
        }
        if  commentData.contentValue.noodle != 0 &&  commentData.contentValue.soup != 0 &&  commentData.contentValue.happiness != 0 {
            initSendButton()
        }
    }
}

extension CommentViewController {
    func preSentWriteCommentView() {
        let controller = UIViewController()
        let writeCommentView: WriteCommentView = UIView.fromNib()
        writeCommentView.delegate = self
        controller.view.stickSubView(writeCommentView)
        let name = stores.first(where: {$0.storeID == commentData.storeID})?.name
        writeCommentView.layoutView(comment: commentData, name: name ?? "")
        self.present(controller, animated: true, completion: nil)
    }
    func initSendButton() {
        let button = UIButton()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        button.layer.cornerRadius = 25
        button.setImage( UIImage(named: "plus"), for: .normal)
        button.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        button.backgroundColor = .black.withAlphaComponent(0.4)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    @objc func sendComment() {
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
    func initValueView(on view: UIView, value: Double, color: CGColor) {
        // round view
            let roundView = UIView(
                frame: CGRect(
                    x: view.bounds.origin.x,
                    y: view.bounds.origin.y,
                    width: view.bounds.size.width - 4,
                    height: view.bounds.size.height - 4
                )
            )
        
            roundView.backgroundColor = .B5
            roundView.layer.cornerRadius = roundView.frame.size.width / 2
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: roundView.bounds.width, height: roundView.bounds.height))
        label.center = CGPoint(x: roundView.center.x, y: roundView.center.y)
        label.textAlignment = .center
        label.text = "\(value)"
        roundView.addSubview(label)
            // bezier path
            let circlePath = UIBezierPath(arcCenter: CGPoint (x: roundView.frame.size.width / 2, y: roundView.frame.size.height / 2),
                                          radius: roundView.frame.size.width / 2,
                                          startAngle: CGFloat(-0.5 * .pi),
                                          endAngle: CGFloat(1.5 * .pi),
                                          clockwise: true)
            // circle shape
            let circleShape = CAShapeLayer()
            circleShape.path = circlePath.cgPath
            circleShape.strokeColor = color
            circleShape.fillColor = UIColor.clear.cgColor
            circleShape.lineWidth = 4
            // set start and end values
            circleShape.strokeStart = 0.0
        circleShape.strokeEnd = value*0.1
            
            // add sublayer
            roundView.layer.addSublayer(circleShape)
            // add subview
            view.addSubview(roundView)
        view.backgroundColor = .B6
    }
}
extension CommentViewController: WrireCommentViewControllerDelegate {
    func didTapSaveComment(_ view: WriteCommentView, text: String) {
        commentData.contenText = text
    }
    
    
}
