//
//  CommentStartingView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import UIKit

protocol CommentStartingViewDelegate: AnyObject {
    func didTapImageView(_ view: CommentStartingView, imagePicker: UIImagePickerController?)
    
    func didFinishPickImage(_ view: CommentStartingView, imagePicker: UIImagePickerController, image: UIImage)
}
class CommentStartingView: UIView {
    weak var delegate: CommentStartingViewDelegate?
    
    var startCommentButton: UIButton? {
        let button = UIButton()
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: SelectionButton.addPicture.rawValue), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 30
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        button.backgroundColor = .black.withAlphaComponent(0.4)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.addTarget(self, action: #selector(startComment), for: .touchUpInside)
        return button
    }
    
    var commentTableView =  UITableView()
    
    var imagePicker: UIImagePickerController? {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        return imagePicker
    }
    
    func layoutStartingView() {
        self.addSubview(commentTableView)
        commentTableView.register(UINib(nibName: String(describing: CommentTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CommentTableViewCell.self))
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        commentTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        commentTableView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        commentTableView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        startCommentButton?.isHidden = false
    }
    
    @objc func startComment(_ sender: UIButton) {
//        sender.isHidden = true
        self.delegate?.didTapImageView(self, imagePicker: imagePicker)
    }
}

extension CommentStartingView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.delegate?.didFinishPickImage(self, imagePicker: picker, image: image)
    }
}
