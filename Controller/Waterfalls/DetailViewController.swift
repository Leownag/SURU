//
//  DetailViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import UIKit
import Kingfisher
import IQKeyboardManagerSwift
protocol DetailViewControllerDelegate: AnyObject {
    func didtapAuthor(_ vc: DetailViewController, targetUserID: String?)
}
class DetailViewController: UIViewController {
    weak var delegate: DetailViewControllerDelegate?
    var account: Account?
    var accountData: [Account] = []
    var comment: Comment?
    var store: Store?
    var newCommet: Comment? {
        didSet {
            guard let data = newCommet?.userComment else { return }
            if data.count != tableView.numberOfRows(inSection: 1) {
            comment = newCommet
            guard let message = comment?.userComment, let currentUserID = UserRequestProvider.shared.currentUserID else { return }
                self.tableView.reloadSections([1], with: .automatic)
                if message.sorted(by: {$0.createdTime > $1.createdTime}).last!.userID == currentUserID  {
                    self.tableView.scrollToRow(at: IndexPath(row: message.count - 1, section: 1), at: .top, animated: true)
                }
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    //上方
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorStackView: UIStackView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func tapFollowButton(_ sender: UIButton) {
        
        guard let userID = UserRequestProvider.shared.currentUserID, let account = account else { return }
        
        if sender.currentTitle == "追蹤" {
            followButton.setTitle("已追蹤", for: .normal)
            AccountRequestProvider.shared.followAccount(currentUserID: userID, tagertUserID: account.userID)
        } else {
            followButton.setTitle("追蹤", for: .normal)
            AccountRequestProvider.shared.unfollowAccount(currentUserID: userID, tagertUserID: account.userID)
        }
    }
    @IBAction func tapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //下方
    
    
    @IBAction func showTextView() {
        inputTextField.becomeFirstResponder()
        textViewBarView.isHidden = false
    }
    @IBAction func tapCommentButton(_ sender: UIButton) {
        // scroller to seaction 1
    }
    @IBAction func tapLikeButton(_ sender: UIButton) {
    }
    
    @IBAction func postComment(_ sender: Any) {
        if let text = inputTextField.text {
            if !text.isEmpty {
                inputTextField.resignFirstResponder()
                publishMessage()
            } else {
                
            }
            inputTextField.text = ""
        }
    }
    func publishMessage() {
        guard let currentUserId = UserRequestProvider.shared.currentUserID,
              let _ = account,
              let comment = comment,
              let content = inputTextField.text else { return }
        var message = Message(userID: currentUserId, message: content)
//        LKProgressHUD.show()
        CommentRequestProvider.shared.addMessage(message: &message, tagertCommentID: comment.commentID) { result in
            switch result {
            case .success(let message):
//                LKProgressHUD.dismiss()
                LKProgressHUD.showSuccess(text: message)
            case .failure:
//                LKProgressHUD.dismiss()
                LKProgressHUD.showFailure(text: "新增評論失敗\n稍候再試")
                
            }
        }
    }
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentCountBtn: UIButton!
    @IBOutlet weak var likeVIew: UIView!
    @IBOutlet weak var textViewBarView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var textViewBarBottomConstraint: NSLayoutConstraint!
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc private func tapAuthorView() {
        dismiss(animated: true) {
            guard let userID = self.comment?.userID else { return }
            self.delegate?.didtapAuthor(self, targetUserID: userID)
        }
        
    }
    func setupTopView() {
        guard let currentUserId = UserRequestProvider.shared.currentUserID,
              let account = account,
              let comment = comment else { return }
        let message = comment.userComment ?? []
        CommentRequestProvider.shared.listenComment(for: comment.commentID) { result in
            switch result {
            case .success(let data):
                self.newCommet = data
            case .failure(let error):
                LKProgressHUD.showFailure(text: "下載評論失敗")
            }
        }
        let tapAuthor = UITapGestureRecognizer(target: self, action: #selector(tapAuthorView))
        authorStackView.isUserInteractionEnabled = true
        authorStackView.addGestureRecognizer(tapAuthor)
        authorImageView.loadImage(account.mainImage, placeHolder: UIImage(named: "mainImage"))
        
        authorNameLabel.text = account.name
        authorNameLabel.adjustsFontSizeToFitWidth = true
        authorNameLabel.setDefultFort()
        
        if let badge = account.badgeStatus {
            badgeImageView.image = UIImage(named: "long_\(badge)")
        } else {
            badgeImageView.isHidden = true
        }
        followButton.layer.cornerRadius = 10
        followButton.clipsToBounds = true
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.B1?.cgColor
        if comment.likedUserList.contains(currentUserId) {
            followButton.setTitle("已追蹤", for: .normal)
        } else {
            followButton.setTitle("追蹤", for: .normal)
        }
    }
    
    func setupButtonView() {
        
        guard let currentUserId = UserRequestProvider.shared.currentUserID,
              let _ = account,
              let comment = comment else { return }
        
        if comment.likedUserList.contains(currentUserId) {
            likeBtn.setImage(UIImage(named: "heart.fill"), for: .normal)
        } else {
            likeBtn.setImage(UIImage(named: "heart.empty"), for: .normal)
        }
        if comment.likedUserList.count != 0 {
            likeBtn.setTitle("\(comment.likedUserList.count)", for: .normal)
        } else {
            likeBtn.setTitle("", for: .normal)
        }
        if let userComment = comment.userComment {
            if !userComment.isEmpty {
                commentCountBtn.setTitle("\(userComment.count)", for: .normal)
            } else {
                commentCountBtn.setTitle("", for: .normal)
            }
        }
    }
    
    func setuptableView() {
        tableView.register(UINib(nibName: String(describing: CommentCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CommentCell.self))
        tableView.register(UINib(nibName: String(describing: CommentMessagesCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CommentMessagesCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        listenToKeyStatus()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        setupTopView()
        setupButtonView()
        setuptableView()
    }
    
    //黑色的view
    lazy var overlayView: UIView = {
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        overlayView.addGestureRecognizer(tap)
        return overlayView
    }()
    //    func hideKeyboardWhenTappedAround(){
    //        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    //        tap.cancelsTouchesInView = false
    //        view.addGestureRecognizer(tap)
    //    }
    func listenToKeyStatus() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
}
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            guard let messages = comment?.userComment else { return 0 }
            return messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let storeData = store, let commentData = comment else { return UITableViewCell() }
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCell.self), for: indexPath) as? CommentCell else { return CommentCell() }
            cell.layoutCell(data: commentData, store: storeData)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentMessagesCell.self), for: indexPath) as? CommentMessagesCell else { return CommentMessagesCell() }
            
            guard let messages = comment?.userComment else { return cell }
            cell.delegate = self
            let dataSource = messages.sorted(by: {$0.createdTime > $1.createdTime})
            let message = dataSource[indexPath.row]
            let author = accountData.first(where: {$0.userID == message.userID}) ?? Account(userID: "123", provider: "")
            cell.layoutCell(commentMessage: messages[indexPath.row], author: author)
            
            return cell
        }
    }
    
    
}
extension DetailViewController: CommentMessagesCellDelegate {
    func didTapMoreButton(_ view: CommentMessagesCell, targetUserID: String?) {
        // 封鎖
    }
    
    
}
extension DetailViewController {
    @objc private func keyboardWillChangeFrame(_ notification: Notification){
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            //键盘的当前高度(弹起时大于0,收起时为0)
            let keyboardH = UIScreen.height - endFrame.origin.y
            
            if keyboardH > 0{
                view.insertSubview(overlayView, belowSubview: textViewBarView)//给背景加黑色透明遮罩
            } else {
                overlayView.removeFromSuperview()
                //移除黑色透明遮罩
                textViewBarView.isHidden = true
            }
            textViewBarBottomConstraint.constant = keyboardH
            view.layoutIfNeeded()
        }
    }
}
