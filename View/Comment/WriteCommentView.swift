//
//  WriteCommentView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import UIKit

protocol WrireCommentViewControllerDelegate: AnyObject {
    func didTapSaveComment(_ view: WriteCommentView, text: String)
}

class WriteCommentView: UIView {
    weak var delegate: WrireCommentViewControllerDelegate?
    var commentData: Comment?
    var storename: String?
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var importTempButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func tapImportTemp(_ sender: Any) {
        contentTextView.text = "| 店家： \(storename!)\n| 時間 ：2022/5/3\n| 品項 ：\(commentData!.meal)\n| 配置 ：\n| 評論：\n"
    }
    @IBAction func tapSendComment(_ sender: Any) {
        self.delegate?.didTapSaveComment(self, text: contentTextView.text!.replacingOccurrences(of: "\n", with: "\\n"))
        self.topMostController()?.dismiss(animated: true, completion: nil)
    }
    func layoutView(comment: Comment,name: String) {
        commentData = comment
        storename = name
        setTextView(textBox: contentTextView)
    }
    
    private func setTextView(textBox: UITextView) {
        textBox.autocorrectionType = .no
        textBox.backgroundColor = .secondarySystemBackground
        textBox.textColor = .secondaryLabel
        textBox.font = UIFont.preferredFont(forTextStyle: .body)
        textBox.layer.cornerRadius = 20
        textBox.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textBox.layer.shadowColor = UIColor.gray.cgColor;
        textBox.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        textBox.layer.shadowOpacity = 0.4
        textBox.layer.shadowRadius = 20
        textBox.layer.masksToBounds = false
    }
    
}
